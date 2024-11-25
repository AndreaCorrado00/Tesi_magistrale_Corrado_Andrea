from sklearn.tree import DecisionTreeClassifier

def LOPOCV_decision_tree(whole_feature_db, selected_features):
    # Model and metrics
    classifier = DecisionTreeClassifier(criterion="gini", random_state=42)
    
    # Initialize lists to store the results
    all_y_true = []
    all_y_pred = []
    all_predictions_by_subs = []  # Will store predictions in the format: [id, y_true, y_pred]
    
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
        
        # Train the model on the training data
        classifier.fit(x_train, y_train)
        
        # Predict on the test data
        y_pred = classifier.predict(x_test)
        
        # Append the true labels and predictions to the overall lists
        all_y_true.extend(y_test)
        all_y_pred.extend(y_pred)
        
        # Append each patient's predictions and true values to the list in the requested format
        for idx in range(len(y_test)):
            # Add the id, true label, and predicted label to the list for the current participant
            all_predictions_by_subs.append([participant, y_test.iloc[idx], y_pred[idx]])

    return classifier,all_y_pred, all_y_true, all_predictions_by_subs, selected_feature_db
