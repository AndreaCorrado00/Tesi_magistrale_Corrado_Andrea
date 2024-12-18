from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import f1_score

def tune_tree_depth_lopocv(X_train,y_train,X_test,y_test, depths):
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

    best_score = -float("inf")
    
    # Tune the maximum depth
    for depth in depths:
        classifier = DecisionTreeClassifier(criterion="entropy", 
                                            max_depth=depth, 
                                            random_state=42,
                                            class_weight="balanced")
        classifier.fit(X_train, y_train)
        
        y_pred = classifier.predict(X_test)
        score = f1_score(y_test, y_pred,average="weighted")  
        
        if score > best_score:
            best_score = score
            best_depth = depth
    
    
    return best_depth
