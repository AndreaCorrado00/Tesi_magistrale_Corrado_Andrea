from sklearn.tree import DecisionTreeClassifier
import shap
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from save_plot import save_plot

def show_SHAP_analysis(whole_feature_db,selected_features,saving_path=None,other_comments=""):
    
    selected_features_no_id_and_class=selected_features.copy()
    
    sub_feature_db=whole_feature_db[whole_feature_db['id'].isin([1,3,4,6,7,8,9,10,11,12])]

    y_true_sub=sub_feature_db["class"]
    selected_features_no_id_and_class.remove('id')
    selected_features_no_id_and_class.remove('class')
    sub_feature_db=sub_feature_db.drop(["id","class"],axis=1)


    # Split 70-30%
    x_train, x_test, y_train, y_test = train_test_split(sub_feature_db[selected_features_no_id_and_class],y_true_sub, test_size=0.3, stratify=y_true_sub, random_state=42)

    # model evaluation
    classifier = DecisionTreeClassifier(criterion="entropy", random_state=42,class_weight="balanced")

    # Train the model on the training data
    classifier.fit(x_train, y_train)


    #%% SHAP PLOT
    # Initialize the SHAP explainer for the DecisionTreeClassifier
    explainer = shap.Explainer(classifier, x_train)

    # Compute SHAP values for the test set
    shap_values = explainer(x_test)
    # Transpose the SHAP values to match (n_classes, n_samples, n_features)
    shap_values_transposed = shap_values.values.transpose(2, 0, 1)  # (n_classes, n_samples, n_features)



    for i in range(len(classifier.classes_)):  # Iterate over the number of classes
        # Create a new figure manually
        fig, ax = plt.subplots(figsize=(10, 6))
        
        # Call shap.summary_plot() with show=False to avoid automatic display
        shap.summary_plot(shap_values_transposed[i], x_test, feature_names=selected_features_no_id_and_class, show=False)

        # Set the title on the current axes after SHAP generates the plot
        ax.set_title(f"SHAP Summary Plot: {classifier.classes_[i]}, "+other_comments)

        # Show the plot
        plt.show()
        
        if saving_path is not None:
            save_plot(fig, saving_path,file_name=f"SHAP_plot_{classifier.classes_[i]}_"+other_comments ,dpi=300)


