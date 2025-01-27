from sklearn.tree import DecisionTreeClassifier
import numpy as np
from tune_tree_depth_lopocv import tune_tree_depth_lopocv  # Assumendo che tune_tree_depth_lopocv sia un modulo personalizzato

def LOPOCV_decision_tree(whole_feature_db, selected_features):
    """
    Perform Leave-One-Patient-Out Cross-Validation (LOPOCV) with a Decision Tree Classifier.

    This function performs a Leave-One-Patient-Out Cross-Validation (LOPOCV) for classification tasks, 
    utilizing a Decision Tree Classifier. The process includes:
    - Splitting the dataset by patient IDs for LOPOCV.
    - Tuning the tree depth for each patient using the `tune_tree_depth_lopocv` method.
    - Training a Decision Tree Classifier with the selected features.
    - Aggregating performance metrics such as predicted and true labels across all patients.
    - Calculating and returning feature importances averaged over all folds.

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
    classifier : sklearn.tree.DecisionTreeClassifier
        The trained Decision Tree classifier for the last fold (patient).
    
    all_y_pred : list of str
        The list of all predicted labels across all patients.
    
    all_y_true : list of str
        The list of all true labels across all patients.
    
    all_predictions_by_subs : list of lists
        A list of predictions for each patient, in the format [patient_id, true_label, predicted_label].
    
    feature_importance_dict : dict
        A dictionary where keys are feature names and values are their average importance scores across all folds.
    
    Notes:
    ------
    - The function uses `tune_tree_depth_lopocv` to automatically determine the optimal tree depth for each fold.
    - The Decision Tree Classifier is trained using the 'entropy' criterion and 'balanced' class weights to handle class imbalances.
    - Feature importance is calculated and averaged across the folds, providing insights into the relative importance of each feature in the classification task.
    """

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
