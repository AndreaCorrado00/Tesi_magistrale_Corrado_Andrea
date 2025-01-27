from sklearn.svm import SVC
from sklearn.inspection import permutation_importance
import numpy as np
from tune_SVM_C_param_LOPOCV import tune_SVM_C_param_LOPOCV 

def LOPOCV_SVM(whole_feature_db, selected_features, kernel_type=None):
    """
    Perform Leave-One-Patient-Out Cross-Validation (LOPOCV) with Support Vector Machine (SVM).

    This function performs Leave-One-Patient-Out Cross-Validation (LOPOCV) for classification tasks 
    using a Support Vector Machine (SVM) classifier. The process includes:
    - Splitting the dataset by patient IDs for LOPOCV.
    - Training an SVM model with the selected features and optimized C parameter.
    - Aggregating performance metrics such as predicted and true labels across all patients.
    - Calculating feature importances using permutation importance, averaged over all folds.

    Parameters:
    -----------
    whole_feature_db : pandas.DataFrame
        A DataFrame containing the entire dataset with patient-specific data.
        It must include columns: 'id', 'class', and feature columns.
    
    selected_features : list of str
        A list of selected feature names to use for training the model.
        This list should exclude 'id' and 'class' columns.
    
    kernel_type : str, optional, default=None
        The kernel type to be used in the SVM model. Possible values are 'linear', 'poly', 'rbf', etc.
        If None, 'linear' is used as the default kernel.

    Returns:
    --------
    classifier : sklearn.svm.SVC
        The trained SVM classifier for the last fold (patient).
    
    all_y_pred : list of str
        The list of all predicted labels across all patients.
    
    all_y_true : list of str
        The list of all true labels across all patients.
    
    all_predictions_by_subs : list of lists
        A list of predictions for each patient, in the format [patient_id, true_label, predicted_label].
    
    feature_importance_dict : dict
        A dictionary where keys are feature names and values are their average importance scores across all folds.
        Feature importance is derived from permutation importance, averaged over all folds.

    Notes:
    ------
    - The function uses the `SVC` class from `sklearn.svm` to train an SVM model with the specified kernel and the optimized `C` parameter.
    - The `C` parameter is optimized using a logarithmic grid search (using `tune_SVM_C_param_LOPOCV`).
    - Class weights are balanced to handle any class imbalance in the dataset.
    - Feature importance is calculated using permutation importance, which provides a measure of how much the feature impacts model performance.
    - Permutation importance is calculated by randomly permuting each feature in the test data and measuring the decrease in model accuracy.
    - The function averages the feature importances across all folds (patients).
    - The `kernel_type` parameter allows customization of the kernel used in the SVM model, with the default being a linear kernel.
    """

    # Model and metrics
    
    # Initialize lists to store results
    all_y_true = []
    all_y_pred = []
    all_predictions_by_subs = []  # Will store predictions in the format: [id, y_true, y_pred]
    cumulative_importance = None  # To aggregate feature importance scores
    
    participant_ids = whole_feature_db['id'].unique()
    
    # Select only the relevant features
    selected_whole_feature_db = whole_feature_db[selected_features]
    selected_feature_db = selected_whole_feature_db.drop(['id', 'class'], axis=1)
    
    # Loop through each participant (Leave-One-Patient-Out Cross-Validation)
    for participant in participant_ids:
        # Separate train and test data for the current participant
        train_data = selected_whole_feature_db[selected_whole_feature_db['id'] != participant]
        test_data = selected_whole_feature_db[selected_whole_feature_db['id'] == participant]
        
        # Split into features and target for train and test sets
        x_train, y_train = train_data.drop(['id', 'class'], axis=1), train_data['class']
        x_test, y_test = test_data.drop(['id', 'class'], axis=1), test_data['class']
        
        # C parameter tuning
        C_candidates = np.logspace(-4, 4, num=9)
        if kernel_type is None:
            kernel_type = 'linear'
        
        C_value = tune_SVM_C_param_LOPOCV(x_train, y_train, x_test, y_test, C_candidates, kernel_type)
        print(f"C parameter for patient {participant}: {C_value}")
        
        # Classifier initialization
        classifier = SVC(kernel=kernel_type, 
                         C=C_value,
                         class_weight='balanced',
                         decision_function_shape='ovr')
        
        # Train the model
        classifier.fit(x_train, y_train)
        
        # Predict on the test data
        y_pred = classifier.predict(x_test)
        
        # Append results
        all_y_true.extend(y_test)
        all_y_pred.extend(y_pred)
        
        # Append patient-specific predictions
        for idx in range(len(y_test)):
            all_predictions_by_subs.append([participant, y_test.iloc[idx], y_pred[idx]])
        
        # Compute permutation importance for the current fold
        perm_importance = permutation_importance(
            classifier, x_test, y_test, n_repeats=10, random_state=42, n_jobs=-1
        )
        feature_importance = perm_importance.importances_mean
        
        # Aggregate feature importance across folds
        if cumulative_importance is None:
            cumulative_importance = feature_importance
        else:
            cumulative_importance += feature_importance
    
    # Average feature importance across folds
    cumulative_importance /= len(participant_ids)
    
    # Create a mapping of features to their importance scores
    feature_importance_dict = {
        feature: importance for feature, importance in zip(selected_feature_db.columns, cumulative_importance)
    }
    
    return classifier, all_y_pred, all_y_true, all_predictions_by_subs,feature_importance_dict
    