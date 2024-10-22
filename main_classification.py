#%% Loading  libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
from sklearn.metrics import classification_report

#%% Adding paths
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Heuristic_classification_phase")
sys.path.append("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/src/Classification_phase")

#%% Loading data
use_filt_data=True;
if use_filt_data:
    data=pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB_FILT.csv")
else:
    data=pd.read_csv("D:/Desktop/ANDREA/Universita/Magistrale/Anno Accademico 2023-2024/TESI/Tesi_magistrale/Data/Processed/AVNRT_DB.csv")


Fs=2035; # Fixed value of samplig rate, Hz

# extraction of labels and signals
y_true=np.array(data['class'])
labels_unique=np.unique(y_true)
data=data.drop('class',axis=1)
#%% Checking data
print(data.head)

# data dimensionality
dims=data.shape
print("Number of signals: "+ str(dims[0]))
print("Number of points: "+ str(dims[1]-1))

# classes
    # just to print 
labels_string = ", ".join(labels_unique)
print("Classes: " + labels_string)

# NaN presence is known but:
has_nan=data.isna().any().any()

if has_nan :
    print("Data have NaN points")
    
# other types of EDA have been made previously

#%% Shoving an example of data series
from show_examples import show_examples
show_examples(data, Fs, 429,800,960)

# %% Stratified train/test split


# %% Building an heuristic classificator
from heuristic_classificator import heuristic_classificator

pred_heuristic=np.empty(dims[0], dtype=object)


for i in range(0,dims[0]):
    pred=heuristic_classificator(data.iloc[i],Fs)
    pred_heuristic[i]=pred
    
# %% Performance of the heuristic classifier
cm = confusion_matrix(y_true, pred_heuristic)

cm_fig=plt.figure()
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["MAP_A","MAP_B","MAP_C"])
disp.plot(cmap=plt.cm.Blues)
plt.title('Confusion Matrix')
    
he_report = classification_report(y_true, pred_heuristic, target_names=labels_unique)
print(he_report)

