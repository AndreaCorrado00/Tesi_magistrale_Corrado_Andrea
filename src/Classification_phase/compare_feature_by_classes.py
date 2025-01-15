import matplotlib.pyplot as plt

def compare_feature_by_classes(feature_db, feature_name):
    # expected a 2 cols dataframe:
        # col 1: feature value 
        # col 2: map of the signals from which the feature is evalated
    map_A_feature=feature_db[feature_name][feature_db["class"]=="Indifferent"]
    map_B_feature=feature_db[feature_name][feature_db["class"]=="Effective"]
    map_C_feature=feature_db[feature_name][feature_db["class"]=="Dangerous"]   
    
    boxplot_data=[map_A_feature,map_B_feature,map_C_feature]
    
    # showing boxplots
    plt.figure()
    plt.boxplot(boxplot_data,showfliers=False)
    plt.xticks([1,2,3],["Indifferent","Effective","Dangerous"])
    plt.title(f"{feature_name}, class distribution")
    