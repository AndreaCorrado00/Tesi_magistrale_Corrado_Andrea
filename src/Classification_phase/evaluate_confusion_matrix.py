def evaluate_confusion_matrix(y_pred, y_true, labels_unique, cm_suptitle=None, cm_title=None, save=False, path=None, saving_name=None):
    """
    Evaluates the classification performance by computing and displaying the confusion matrix and a detailed classification report.
    Optionally saves the confusion matrix plot to a specified location.

    Parameters:
    -----------
    y_pred : list or array-like
        Predicted class labels.

    y_true : list or array-like
        True class labels.

    labels_unique : list
        List of unique class labels to be used for the confusion matrix.

    cm_suptitle : str, optional
        The supertitle of the confusion matrix plot. Default is None.

    cm_title : str, optional
        The title of the confusion matrix plot. Default is None.

    save : bool, optional
        If True, saves the confusion matrix plot. Default is False.

    path : str, optional
        Path where the confusion matrix plot will be saved. Required if `save` is True.

    saving_name : str, optional
        Name to use for saving the plot. Required if `save` is True.

    Returns:
    --------
    pd.DataFrame
        A DataFrame containing the detailed classification report (precision, recall, F1-score, support for each class).
    """
    cm = confusion_matrix(y_true, y_pred, labels=labels_unique)
    print(labels_unique)
    cm_fig, ax = plt.subplots()
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=labels_unique)
    disp.plot(cmap=plt.cm.Blues, ax=ax)
    plt.suptitle(cm_suptitle)
    plt.title(cm_title, fontsize=10)
    
    # Report of performance: baseline
    he_report = classification_report(y_true, y_pred, target_names=labels_unique, labels=labels_unique)
    print(he_report)
    
    # Saving confusion matrix
    if save:
        save_plot(cm_fig, path, saving_name)
    
    dict_he_report = classification_report(
        y_true, y_pred, target_names=labels_unique, labels=labels_unique, output_dict=True
    )
    dict_he_report = pd.DataFrame(dict_he_report).transpose()
    dict_he_report["support"] = dict_he_report["support"].astype(int)
    return dict_he_report
