import matplotlib.pyplot as plt

def compare_feature_by_classes(feature_db, feature_name):
    # expected a 2 cols dataframe:
        # col 1: feature value 
        # col 2: map of the signals from which the feature is evalated
    map_A_feature=feature_db[feature_name][feature_db["class"]=="MAP_A"]
    map_B_feature=feature_db[feature_name][feature_db["class"]=="MAP_B"]
    map_C_feature=feature_db[feature_name][feature_db["class"]=="MAP_C"]   
    
    boxplot_data=[map_A_feature,map_B_feature,map_C_feature]
    
    # showing boxplots
    plt.figure()
    plt.boxplot(boxplot_data,showfliers=False)
    plt.xticks([1,2,3],["MAP A","MAP B","MAP C"])
    plt.title(f"Feature: {feature_name}, class distribution")
    