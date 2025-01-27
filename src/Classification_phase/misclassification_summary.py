import pandas as pd

def misclassification_summary(whole_dataset, y_pred, classes):
    """
    Summarizes misclassifications for each subject in the dataset, comparing true class labels with predicted labels.

    Parameters:
    -----------
    whole_dataset : pd.DataFrame
        The dataset containing the true class labels and subject IDs. It must have columns 'id' and 'class'.

    y_pred : np.array or pd.Series
        The predicted class labels for the whole dataset.

    classes : list
        The list of unique class labels.

    Returns:
    --------
    pd.DataFrame
        A DataFrame where each row corresponds to a subject and columns show misclassification statistics.
    """
    results = []
    whole_dataset = whole_dataset.copy()  # To avoid modifying the original dataset
    
    # Indices to navigate through y_pred
    start_idx = 0
    
    # Group the data by 'id' (for each subject)
    for sub_id, group in whole_dataset.groupby('id'):
        misclass_dict = {'id': sub_id}
        
        # Calculate the length of the group
        M = len(group)
        
        # Get the predicted labels for the current subject
        y_pred_for_sub = y_pred[start_idx:start_idx + M]
        
        # Update start_idx for the next subject
        start_idx += M
        
        # Add y_pred as a column to the group (for misclassification calculation)
        group['y_pred'] = y_pred_for_sub
        
        # Calculate true positives for each class
        true_positives = {cls: (group['class'] == cls).sum() for cls in classes}
        
        # For each class, calculate misclassifications
        for true_class in classes:
            for pred_class in classes:
                if true_class != pred_class:
                    # Count misclassifications of true_class as pred_class for this subject
                    count = ((group['class'] == true_class) & (group['y_pred'] == pred_class)).sum()
                    
                    # Calculate the percentage of misclassifications
                    if true_positives[true_class] > 0:
                        percentage = f"{count} / {true_positives[true_class]}"
                    else:
                        percentage = "-"  # Handle case with no true positives

                    misclass_dict[f"{true_class}->{pred_class}"] = percentage
        
        # Append the results for the current subject to the list
        results.append(misclass_dict)

    # Create a DataFrame with the results
    summary_df = pd.DataFrame(results)
    
    # Fill NaN values with 0
    summary_df = summary_df.fillna(0)  

    return summary_df
