from sklearn.tree import DecisionTreeClassifier
from sklearn.svm import SVC
import shap
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from save_plot import save_plot
import pandas as pd

def show_SHAP_analysis(whole_feature_db, selected_features, model_type='tree', kernel_type='linear', saving_path=None, other_comments=""):
    """
    Performs SHAP (SHapley Additive exPlanations) analysis on the provided dataset to interpret the predictions of a given model.
    This function supports two types of models: Decision Tree ('tree') and Support Vector Machine (SVM, 'SVM').

    The SHAP analysis helps to understand the feature importance and the contribution of each feature to model predictions.
    The function generates summary plots to visualize the impact of each feature across all samples.

    Parameters:
    -----------
    whole_feature_db : pandas.DataFrame
        The dataset containing the features, labels, and patient IDs. It should have columns for 'id', 'class', and features.
        
    selected_features : list of str
        List of feature names to be used for model training and SHAP analysis. It is assumed that the list includes the relevant features
        along with 'id' and 'class' (to be dropped during processing).

    model_type : str, optional, default='tree'
        Specifies the model type for SHAP analysis. Available options are:
        - 'tree' for DecisionTreeClassifier
        - 'SVM' for Support Vector Machine with specified kernel type

    kernel_type : str, optional, default='linear'
        Specifies the kernel type for the SVM model. Only relevant if `model_type='SVM'`. Typical values include 'linear', 'rbf', etc.

    saving_path : str, optional, default=None
        If provided, the generated SHAP plots will be saved to the specified path with the given file name.

    other_comments : str, optional, default=""
        Additional comments to include in the title of the SHAP plots for better context (e.g., experiment description).

    Returns:
    --------
    None
        The function generates and displays SHAP summary plots for each class in the classifier. Optionally, the plots can be saved to disk.
    
    Notes:
    ------
    - The SHAP analysis is performed by fitting the model to a 70% subset of the data, leaving 30% for testing.
    - The dataset is filtered to include specific patients for SHAP interpretation.
    - For Decision Tree models, SHAP TreeExplainer is used. For SVM models, SHAP KernelExplainer is used.
    - The function automatically handles feature names and creates summary plots for each class in a multi-class classification problem.
    - The generated plots are displayed using `matplotlib` and can be saved with high resolution if `saving_path` is provided.
    """

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
