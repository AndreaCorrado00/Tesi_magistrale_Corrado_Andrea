from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC
import shap
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from save_plot import save_plot
import pandas as pd

def show_SHAP_analysis(whole_feature_db, selected_features, model_type='tree', kernel_type='linear', saving_path=None, other_comments=""):
    selected_features_no_id_and_class = selected_features.copy()

    # Filter specific patients and prepare data
    sub_feature_db = whole_feature_db[whole_feature_db['id'].isin([1, 3, 4, 6, 7, 8, 9, 10, 11, 12])]
    y_true_sub = sub_feature_db["class"]
    selected_features_no_id_and_class.remove('id')
    selected_features_no_id_and_class.remove('class')
    sub_feature_db = sub_feature_db.drop(["id", "class"], axis=1)

    # Split dataset (70-30%)
    x_train, x_test, y_train, y_test = train_test_split(
        sub_feature_db[selected_features_no_id_and_class],
        y_true_sub, 
        test_size=0.3, 
        stratify=y_true_sub, 
        random_state=42
    )

    # Model initialization
    if model_type == 'tree':
        classifier = DecisionTreeClassifier(criterion="entropy", random_state=42, class_weight="balanced")
    elif model_type == 'SVM':
        classifier = SVC(kernel=kernel_type, 
                         C=100, 
                         class_weight='balanced',
                         decision_function_shape='ovr')

    # Train the model
    classifier.fit(x_train, y_train)

    # SHAP analysis
    if model_type == 'tree':
        
        explainer = shap.TreeExplainer(classifier, x_train)
        shap_values = explainer(x_test)
    elif model_type == 'SVM':
        def model_predict(X):
            # Ensure X is always a DataFrame with proper column names
            if not isinstance(X, pd.DataFrame):
                X = pd.DataFrame(X, columns=x_train.columns)
            return classifier.decision_function(X)
        
        explainer = shap.KernelExplainer(model_predict, shap.sample(x_train, 100))
        shap_values = explainer.shap_values(x_test)
        
    # Generate SHAP plots
    for i, class_name in enumerate(classifier.classes_):
        fig, ax = plt.subplots(figsize=(10, 6))
        
        # Use SHAP summary plot for the i-th class
        shap.summary_plot(shap_values[:, :, i], x_test, feature_names=selected_features_no_id_and_class, show=False)
        ax.set_title(f"SHAP Summary Plot: {class_name}, {other_comments}")
        
        plt.show()

        if saving_path is not None:
            save_plot(fig, saving_path, file_name=f"SHAP_plot_{class_name}_{other_comments}", dpi=300)
