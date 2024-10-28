def evaluate_confusion_matrix(y_pred,y_true,labels_unique,cm_suptitle=None,cm_title=None,save=False, path=None,saving_name=None):
    from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
    from sklearn.metrics import classification_report
    import sys
    import matplotlib.pyplot as plt
    sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")
    from save_plot import save_plot
    
    cm = confusion_matrix(y_true, y_pred)
    
    cm_fig, ax = plt.subplots()  
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=labels_unique)
    disp.plot(cmap=plt.cm.Blues, ax=ax)
    plt.suptitle(cm_suptitle)
    plt.title(cm_title,fontsize=10)
    
    # Report of performance: baseline    
    he_report = classification_report(y_true, y_pred, target_names=labels_unique)
    print(he_report)
    # saving confusion matrix
    if save:
        save_plot(cm_fig,path,saving_name)