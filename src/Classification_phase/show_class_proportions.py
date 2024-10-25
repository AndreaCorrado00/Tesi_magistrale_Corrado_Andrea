def show_class_proportions(labels,labels_unique):
    import numpy as np
    import pandas as pd
    
    N=labels.shape[0]
    print(f"Number of signals for each Map")
    for i in range(0,labels_unique.shape[0]):
        label_subset=np.array(labels==labels_unique[i])
        n=np.sum(label_subset)
        prop=round((n/N)*100,2)
        print(f" - {labels_unique[i]}: {n} signals ({prop} %)")
        
        

