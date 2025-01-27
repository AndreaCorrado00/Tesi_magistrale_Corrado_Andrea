from sklearn.ensemble import RandomForestClassifier
import numpy as np

def LOPOCV_RandomForest(whole_feature_db, selected_features, forest_size=100, max_depth=None):
    """
    Perform Leave-One-Patient-Out Cross-Validation (LOPOCV) with Random Forest Classifier.

    This function implements a Leave-One-Patient-Out Cross-Validation (LOPOCV) for classification tasks 
    using a Random Forest Classifier. The process includes:
    - Splitting the dataset by patient IDs for LOPOCV.
    - Training a Random Forest model with the selected features.
    - Aggregating performance metrics such as predicted and true labels across all patients.
    - Calculating and returning feature importances based on the model's feature importances, averaged over all folds.

    Parameters:
    -----------
    whole_feature_db : pandas.DataFrame
        A DataFrame containing the entire dataset with patient-specific data.
        It must include columns: 'id', 'class', and feature columns.
    
    selected_features : list of str
        A list of selected feature names to use for training the model.
        This list should exclude 'id' and 'class' columns.
    
    forest_size : int, optional, default=100
        The number of trees in the Random Forest. A higher value may improve performance but also increases computation time.
    
    max_depth : int or None, optional, default=None
        The maximum depth of the trees in the Random Forest. If None, nodes are expanded until all leaves are pure.

    Returns:
    --------
    classifier : sklearn.ensemble.RandomForestClassifier
        The trained Random Forest classifier for the last fold (patient).
    
    all_y_pred : list of str
        The list of all predicted labels across all patients.
    
    all_y_true : list of str
        The list of all true labels across all patients.
    
    all_predictions_by_subs : list of lists
        A list of predictions for each patient, in the format [patient_id, true_label, predicted_label].
    
    feature_importance_dict : dict
        A dictionary where keys are feature names and values are their average importance scores across all folds.
        Feature importance is derived from the Random Forest's built-in feature importances, averaged over all folds.

    Notes:
    ------
    - The function uses `RandomForestClassifier` with 'balanced' class weights to handle class imbalances in the data.
    - Feature importance is derived directly from the `RandomForestClassifier.feature_importances_` attribute, which reflects 
      the relative importance of each feature based on how well they contribute to reducing impurity across all trees in the forest.
    - The function averages the feature importances across all folds (patients).
    - The `forest_size` parameter allows for adjusting the number of trees in the Random Forest, with a default of 100.
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
        classifier = RandomForestClassifier(
            n_estimators=forest_size,
            max_depth=max_depth,
            class_weight='balanced',
            random_state=42
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
        
        # Extract the feature importance of the model
        feature_importance = classifier.feature_importances_  
        
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
