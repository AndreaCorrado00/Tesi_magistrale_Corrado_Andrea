

import matplotlib.pyplot as plt
from save_plot import save_plot

def analyse_feature_importance(feature_importance, plot_title="Feature importance",th=None, saving_plot=False, other_fig_path=None, file_name='features_importance'):
    """
    Analyzes and visualizes the feature importance of a model, allowing filtering by a threshold, and optionally saving the plot.
    
    Parameters:
    -----------
    feature_importance : dict
        A dictionary where keys are feature names and values are the corresponding importance values.
    th : float, optional, default=None
        The threshold for selecting features based on their importance. Features with importance greater than `th` will be selected. 
        If `None`, all features are considered.
    saving_plot : bool, optional, default=False
        A flag indicating whether to save the feature importance plot.
    other_fig_path : str, optional, default=None
        The path where to save the plot if `saving_plot` is `True`. Must include file extension (e.g., '.png').
    file_name : str, optional, default='features_importance'
        The name of the file to save the plot as.
    
    Returns:
    --------
    list : A list of feature names that have an importance greater than `th` (or all features if `th` is `None`).
        The list includes 'id' and 'class' as the first and last elements, respectively.
    
    Behavior:
    ---------
    - Filters out the 'id' and 'class' features from the importance analysis.
    - Sorts the features by their absolute importance in descending order.
    - Prints the cumulative feature importance.
    - Selects features with importance higher than the threshold `th` (if provided).
    - Visualizes the feature importance as a horizontal bar chart.
    - Saves the plot if `saving_plot` is `True` and `other_fig_path` is specified.
    """
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
    importance_fig, ax = plt.subplots(figsize=(12, 10))
    plt.barh(feature_names, importance_scores, color="skyblue")
    plt.xlabel("Importance")
    plt.title(plot_title,fontsize=18)
    plt.gca().invert_yaxis()  # Invert y-axis to have the highest importance at the top
    plt.yticks(fontsize=10)
    plt.show()

    # Save the plot if a save function is provided
    if saving_plot and other_fig_path:
        save_plot(importance_fig, other_fig_path, file_name=file_name)
        
    selected_features.insert(0, 'id')
    selected_features.append('class')
    return selected_features
