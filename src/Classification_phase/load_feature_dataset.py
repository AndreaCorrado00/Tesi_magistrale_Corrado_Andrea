import pandas as pd
import os
def load_feature_dataset(dataset_path, dataset_name):
    full_name=os.path.join(dataset_path, dataset_name+".txt")
    table= pd.read_csv(full_name, delimiter=',')
    # Directory of the dataset requested


    # Final dataset
    data = pd.DataFrame(table) #whole features dataset
    features_db=data.iloc[:,1:-1]

    # Return the cleaned dataset, signals without duplicates, y_true without duplicates
    return data, features_db
