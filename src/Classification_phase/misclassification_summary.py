import pandas as pd

def misclassification_summary(whole_dataset, y_pred, classes):
    results = []
    whole_dataset = whole_dataset.copy()  # To avoid modifying the original dataset
    whole_dataset['y_pred'] = y_pred
    
    for sub_id, group in whole_dataset.groupby('id'):
        misclass_dict = {'id': sub_id}
        
        # Calculate true positives for each class
        true_positives = {}
        for true_class in classes:
            true_positives[true_class] = (group['class'] == true_class).sum()
        
        # For each pair of true and predicted classes, calculate misclassification percentages
        for true_class in classes:
            for pred_class in classes:
                if true_class != pred_class:
                    # Count misclassifications of true_class as pred_class for this subject
                    count = ((group['class'] == true_class) & (group['y_pred'] == pred_class)).sum()
                    
                    # Calculate the percentage of misclassifications
                    if true_positives[true_class] > 0:
                        percentage = f"{count} / {true_positives[true_class]}"
                    else:
                        percentage = "-"  # To handle the case of no true positives

                    misclass_dict[f"{true_class}->{pred_class}"] = percentage
        
        results.append(misclass_dict)

    summary_df = pd.DataFrame(results)
    
    summary_df = summary_df.fillna(0)  # Fill NaN values with 0 if necessary

    return summary_df
