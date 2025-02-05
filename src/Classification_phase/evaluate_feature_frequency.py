def evaluate_feature_frequency(tree_features,mlr_features,svm_features):
    tree_features=tree_features.copy()
    mlr_features=mlr_features.copy()
    svm_features=svm_features.copy()
    
    tree_features.remove('id')
    tree_features.remove('class')
    
    mlr_features.remove('id')
    mlr_features.remove('class')
    
    svm_features.remove('id')
    svm_features.remove('class')
    
    # whole set of features names selected 
    whole_features_name=tree_features+mlr_features+svm_features
    
    features_frequencies={}
    
    # counter
    for elem in whole_features_name:
        if elem not in features_frequencies.keys():
            features_frequencies[elem]=1
        else:
            features_frequencies[elem]=features_frequencies[elem]+1
        
    # diplayer
    three_times=[]
    two_times=[]
    one_time=[]
    for key in features_frequencies.keys():
        if features_frequencies[key]==3:
            three_times.append(key)
        elif features_frequencies[key]==2:
            two_times.append(key)
        else:
            one_time.append(key)
            
    print("Features selected 3 times:")
    for feature_name in three_times:
        print(f"   - {feature_name}")
    print("\nFeatures selected 2 times:")
    for feature_name in two_times:
        print(f"   - {feature_name}")
    print("\nFeatures selected 1 time:")
    for feature_name in one_time:
        print(f"   - {feature_name}")           

