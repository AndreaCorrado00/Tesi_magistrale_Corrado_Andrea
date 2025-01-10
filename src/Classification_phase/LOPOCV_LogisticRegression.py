from sklearn.linear_model import LogisticRegression
import numpy as np

def LOPOCV_LogisticRegression(whole_feature_db, selected_features):
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
