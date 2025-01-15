from sklearn.tree import DecisionTreeClassifier
import numpy as np
from tune_tree_depth_lopocv import tune_tree_depth_lopocv  # Assumendo che tune_tree_depth_lopocv sia un modulo personalizzato

def LOPOCV_decision_tree(whole_feature_db, selected_features):
    # Initialize lists to store the results
    all_y_true = []
    all_y_pred = []
    all_predictions_by_subs = []  # Will store predictions in the format: [id, y_true, y_pred]
    cumulative_importance = None  # To aggregate feature importance scores
    
    participant_ids = whole_feature_db['id'].unique()
    
    # Prepare to store feature importance
    num_features = len(selected_features) - 2  # Exclude 'id' and 'class'
    feature_importances = np.zeros(num_features)
    
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
        
        # Depth tuning
        max_depth = tune_tree_depth_lopocv(x_train, y_train, x_test, y_test, np.arange(3, 15, dtype=int))
        print(f"tree depth for patient: {participant}: {max_depth}")
        
        # Classifier initialization for Decision Tree
        classifier = DecisionTreeClassifier(criterion="entropy", random_state=42, max_depth=max_depth, class_weight="balanced")
        
        # Train the model
        classifier.fit(x_train, y_train)
        
        # Predict on the test data
        y_pred = classifier.predict(x_test)
        
        # Append results
        all_y_true.extend(y_test)
        all_y_pred.extend(y_pred)
        
        # Update feature importance
        feature_importances += classifier.feature_importances_
        
        # Append patient-specific predictions
        for idx in range(len(y_test)):
            all_predictions_by_subs.append([participant, y_test.iloc[idx], y_pred[idx]])
    
    # Average feature importance across folds
    feature_importances /= len(participant_ids)
    
    # Create a mapping of features to their importance scores
    feature_importance_dict = {
        feature: importance for feature, importance in zip(selected_feature_db.columns, feature_importances)
    }
    
    return classifier, all_y_pred, all_y_true, all_predictions_by_subs, feature_importance_dict
