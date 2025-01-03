from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler
from sklearn.pipeline import Pipeline
import pandas as pd
def impute_scale_dataset(whole_feature_db):


    # Assume whole_feature_db is your original DataFrame
    # Exclude 'id' (first column) and 'class' (last column)
    numerical_cols = whole_feature_db.select_dtypes(include=['float64', 'int64']).columns.tolist()
    categorical_cols = whole_feature_db.select_dtypes(include=['object']).columns.tolist()

    # Exclude 'id' and 'class' columns from numerical and categorical lists
    numerical_cols.remove('id')  # Remove patient ID from numerical features
    categorical_cols.remove('class')  # Remove the target 'class' from categorical features


    # Define preprocessing steps
    preprocessor = Pipeline([
        ('imputer', SimpleImputer(strategy='mean')),  # Impute numerical data ( mean imputation)
        ('scaler', MinMaxScaler())  # Apply MinMax scaling
    ])

    # Apply transformations
    X = whole_feature_db.drop(['id', 'class'], axis=1)  # Drop the 'id' and 'class' columns from the features

    # Fit and transform the data
    X_processed = preprocessor.fit_transform(X)
    
    

    # Convert processed data back to a DataFrame
    processed_df = pd.DataFrame(X_processed, columns=numerical_cols)
    
    processed_df.insert(0,'id',whole_feature_db['id'])
    processed_df['class']=whole_feature_db['class']

    return processed_df