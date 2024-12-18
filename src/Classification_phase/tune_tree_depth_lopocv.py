from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import f1_score

def tune_tree_depth_lopocv(whole_feature_db, selected_features, depths):
    """
    Function to tune the maximum depth of a decision tree using Leave-One-Patient-Out Cross-Validation (LOPOCV).

    Parameters:
    -----------
    whole_feature_db : DataFrame
        The complete dataset containing features, IDs, and the target class.
    selected_features : list
        List of selected features to use for training.
    depths : list
        A list of depths to test for the decision tree.

    Returns:
    --------
    optimal_depth : int
        The best depth selected based on LOPOCV.
    """
    participant_ids = whole_feature_db['id'].unique()
    best_depths = []  # Store the best depth for each fold
    
    # Select only the relevant features
    selected_whole_feature_db = whole_feature_db[selected_features]
    
    for participant in participant_ids:
        # Separate training and testing data for the current participant
        train_data = selected_whole_feature_db[selected_whole_feature_db['id'] != participant]
        test_data = selected_whole_feature_db[selected_whole_feature_db['id'] == participant]
        
        X_train, y_train = train_data.drop(['id', 'class'], axis=1), train_data['class']
        X_test, y_test = test_data.drop(['id', 'class'], axis=1), test_data['class']
        
        best_depth = None
        best_score = -float("inf")
        
        # Tune the maximum depth
        for depth in depths:
            classifier = DecisionTreeClassifier(criterion="entropy", max_depth=depth, random_state=42,class_weight="balanced")
            classifier.fit(X_train, y_train)
            
            y_pred = classifier.predict(X_test)
            score = f1_score(y_test, y_pred,average="weighted")  
            
            if score > best_score:
                best_score = score
                best_depth = depth
        
        best_depths.append(best_depth)  # Save the best depth for this fold

    # Determine the optimal depth globally (e.g., the most frequent depth across folds)
    optimal_depth = max(set(best_depths), key=best_depths.count)
    return optimal_depth
