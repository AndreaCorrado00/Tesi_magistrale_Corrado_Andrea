from sklearn.svm import SVC
from sklearn.metrics import f1_score

def tune_SVM_C_param_LOPOCV(X_train, y_train, X_test, y_test, C_candidates, kernel_type=None):
    """
    Tune the 'C' hyperparameter for Support Vector Machine (SVM) using Leave-One-Patient-Out Cross-Validation (LOPOCV).

    This function iterates over a range of 'C' parameter values for the SVM model and selects the best value 
    based on the F1 score (weighted) computed on the test set. It evaluates the classifier performance using
    Leave-One-Patient-Out Cross-Validation (LOPOCV), where the model is trained on all data except one patient's data
    and evaluated on that patient.

    Parameters:
    -----------
    X_train : pandas.DataFrame or numpy.ndarray
        The training feature set (excluding the target variable) for the current fold (all but one patient).
    
    y_train : pandas.Series or numpy.ndarray
        The true labels (target variable) for the training set corresponding to `X_train`.

    X_test : pandas.DataFrame or numpy.ndarray
        The test feature set for the current fold (data for the single patient left out for validation).
    
    y_test : pandas.Series or numpy.ndarray
        The true labels (target variable) for the test set corresponding to `X_test`.

    C_candidates : list or numpy.ndarray
        A list or array of potential values for the 'C' hyperparameter of the SVM classifier. The 'C' parameter
        controls the trade-off between achieving a low error on the training data and minimizing the model complexity.

    kernel_type : str, optional, default=None
        The kernel to be used in the SVM model. If None, it defaults to 'linear'. Other options include 'poly', 'rbf', etc.

    Returns:
    --------
    best_C : float
        The value of the 'C' parameter that yielded the highest weighted F1 score on the validation (test) set.
    
    Notes:
    ------
    - The function uses the `SVC` class from `sklearn.svm` to train the model.
    - The F1 score is used as the evaluation metric to balance precision and recall, with a preference for balancing class distribution.
    - The `class_weight='balanced'` ensures that class imbalance is handled by adjusting the weights of the classes inversely proportional to their frequency.
    - The `decision_function_shape='ovr'` indicates that a one-vs-all strategy is used for multi-class classification.
    - The best 'C' value is chosen based on the maximum F1 score across all candidate values.
    """

    
    
    best_score = -float("inf")

    # Tune the maximum depth
    for C in C_candidates:
        classifier = SVC(kernel=kernel_type, 
                         C=C,
                         class_weight='balanced',
                         decision_function_shape='ovr',  # One-vs-All strategy
                         )
        classifier.fit(X_train, y_train)
        
        y_pred = classifier.predict(X_test)
        score = f1_score(y_test, y_pred,average="weighted")  
        
        if score > best_score:
            best_score = score
            best_C = C
    
    
    return best_C
