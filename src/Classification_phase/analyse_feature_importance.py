import matplotlib.pyplot as plt
from save_plot import save_plot

def analyse_feature_importance(feature_importance, th=None, saving_plot=False, other_fig_path=None, file_name='features_importance'):
    if th is None:
        th = 0.01  # Default threshold value for feature importance

    # Exclude 'id' and 'class' from the feature importance analysis
    filtered_feature_importance = {
        feature: abs(importance) for feature, importance in feature_importance.items()
        if feature not in ['id', 'class']
    }

    # Sort the filtered feature importance dictionary by importance value in descending order
    sorted_feature_importance = dict(sorted(filtered_feature_importance.items(), key=lambda item: item[1], reverse=True))

    # Print cumulative feature importance in sorted order and select features above the threshold
    print("\nCumulative Feature Importance:")
    selected_features = []  # Initialize the selected_features list
    for feature, importance in sorted_feature_importance.items():
        print(f"{feature}: {importance:.4f}")
        # Add feature to the selected_features list if its importance is higher than the threshold
        if th is not None and importance > th:
            selected_features.append(feature)

    if th is not None:
        print(f"\nSelected Features with Importance Higher than {th}:")
        print(selected_features)
    
    # Extract feature names and their importance scores for plotting
    feature_names, importance_scores = zip(*sorted_feature_importance.items())

    # Plot the feature importance histogram
    importance_fig, ax = plt.subplots()
    plt.barh(feature_names, importance_scores, color="skyblue")
    plt.xlabel("Importance")
    plt.title("Feature Importance: whole set of features")
    plt.gca().invert_yaxis()  # Invert y-axis to have the highest importance at the top
    plt.show()

    # Save the plot if a save function is provided
    if saving_plot and other_fig_path:
        save_plot(importance_fig, other_fig_path, file_name=file_name)
        
    selected_features.insert(0, 'id')
    selected_features.append('class')
    return selected_features
