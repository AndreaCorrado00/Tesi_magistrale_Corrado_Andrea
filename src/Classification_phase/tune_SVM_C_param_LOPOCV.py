from sklearn.svm import SVC
from sklearn.metrics import f1_score

def tune_SVM_C_param_LOPOCV(X_train,y_train,X_test,y_test,C_candidates,kernel_type=None):
    """
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
