from sklearn.svm import SVC
from sklearn.inspection import permutation_importance
import numpy as np
from tune_SVM_C_param_LOPOCV import tune_SVM_C_param_LOPOCV 

def LOPOCV_SVM(whole_feature_db, selected_features, kernel_type=None):
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
        C_candidates = np.logspace(-3, 3, num=7)
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
    