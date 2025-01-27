from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler
from sklearn.pipeline import Pipeline
import pandas as pd
def impute_scale_dataset(whole_feature_db):
    """
    Preprocesses the given dataset by imputing missing values in numerical features and scaling them using MinMaxScaler.
    The 'id' and 'class' columns are excluded from processing and returned in the final output.

    Parameters:
    -----------
    whole_feature_db : pd.DataFrame
        The original dataset containing both features and labels. 
        It is assumed that the dataset includes 'id' (unique identifier) and 'class' (target) columns.

    Returns:
    --------
    pd.DataFrame
        A DataFrame containing the processed features, with missing values imputed, numerical features scaled,
        and the 'id' and 'class' columns preserved.
    
    Behavior:
    ---------
    - Excludes the 'id' and 'class' columns before applying imputation and scaling.
    - Imputes missing values in numerical columns using the mean strategy.
    - Scales numerical features using MinMaxScaler.
    - The 'id' and 'class' columns are added back to the processed dataset.
    """



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