def analyse_SVM_feature_importance(feature_importance, th=None):
    # Assuming feature_importance is a dictionary where keys are feature names and values are their importance scores
    th = 0.01  # Define the threshold value for feature importance (adjust as needed)

    # Sort the feature importance dictionary by the importance value in descending order
    sorted_feature_importance = dict(sorted(feature_importance.items(), key=lambda item: item[1], reverse=True))

    # Print cumulative feature importance in sorted order and select features above the threshold
    print("Cumulative Feature Importance:")
    selected_features = []  # List to store the names of selected features

    for feature, importance in sorted_feature_importance.items():
        print(f"{feature}: {importance:.4f}")
        
        # Add feature to the selected_features list if its importance is higher than the threshold
        
        if th is not None:
            if importance > th:
                selected_features.append(feature)
                # Print the selected features with importance above the threshold
                
    if th is not None:         
        print(f"\nSelected Features with Importance Higher than {th}:")
        print(selected_features)
        return selected_features
 
    
    

