from sklearn.linear_model import LogisticRegression
import numpy as np

def LOPOCV_LogisticRegression(whole_feature_db, selected_features):
    """
    Perform Leave-One-Patient-Out Cross-Validation (LOPOCV) with Logistic Regression.

    This function performs a Leave-One-Patient-Out Cross-Validation (LOPOCV) for classification tasks 
    using a Logistic Regression model. The process includes:
    - Splitting the dataset by patient IDs for LOPOCV.
    - Training a Logistic Regression model with the selected features.
    - Aggregating performance metrics such as predicted and true labels across all patients.
    - Calculating and returning feature importances based on model coefficients, averaged over all folds.

    Parameters:
    -----------
    whole_feature_db : pandas.DataFrame
        A DataFrame containing the entire dataset with patient-specific data.
        It must include columns: 'id', 'class', and feature columns.
    
    selected_features : list of str
        A list of selected feature names to use for training the model.
        This list should exclude 'id' and 'class' columns.

    Returns:
    --------
    classifier : sklearn.linear_model.LogisticRegression
        The trained Logistic Regression classifier for the last fold (patient).
    
    all_y_pred : list of str
        The list of all predicted labels across all patients.
    
    all_y_true : list of str
        The list of all true labels across all patients.
    
    all_predictions_by_subs : list of lists
        A list of predictions for each patient, in the format [patient_id, true_label, predicted_label].
    
    feature_importance_dict : dict
        A dictionary where keys are feature names and values are their average importance scores across all folds.
        Feature importance is derived from the model's coefficients, normalized to the sum of their absolute values.

    Notes:
    ------
    - The function uses `LogisticRegression` with a multinomial logistic model and 'lbfgs' solver, designed to handle multiclass classification.
    - The classifier is trained with 'balanced' class weights to handle class imbalances in the data.
    - Feature importance is derived from the model's coefficients, and the importance is normalized for each fold and averaged across all folds.
    - The maximum number of iterations is set to 1000 to ensure convergence for complex datasets.
    """

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
        
        # Classifier initialization for Logistic Regression
        classifier = LogisticRegression(
            multi_class='multinomial', 
            solver='lbfgs',
            class_weight='balanced',
            max_iter=1000  # Ensure convergence for complex datasets
        )
        
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
        
        # Extract the coefficients (importance) of the model
        feature_importance = classifier.coef_.flatten()  # Flattening in case of multiple classes
        
        # Normalize feature importance (sum of absolute coefficients for each fold)
        norm_factor = np.sum(np.abs(feature_importance))
        if norm_factor != 0:
            feature_importance /= norm_factor  # Normalize by the sum of absolute values
        
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
    
    return classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance_dict
