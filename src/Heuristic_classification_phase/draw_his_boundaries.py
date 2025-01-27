import matplotlib.pyplot as plt

"""
Draws boundaries and optional filled areas on a plot to visualize atrial and ventricular intervals, with customizable thresholds.

Parameters:
    atr_t (float): The x-coordinate representing the atrial boundary on the plot.
    ven_t (float): The x-coordinate representing the ventricular boundary on the plot.
    th_his (float, optional): Threshold value for drawing horizontal dashed lines at +/-th_his. If None, no threshold lines are drawn.
    disp_atr_vent_boxes (bool, optional): If True, displays additional shaded regions between the atrial boundary and the origin.

Behavior:
    - If `th_his` is provided:
        - Dashed horizontal red lines are drawn at `+th_his` and `-th_his`.
        - Vertical dashed grey lines mark the atrial (`atr_t`) and ventricular (`ven_t`) boundaries.
    - If `disp_atr_vent_boxes` is True:
        - Adds shaded green regions within the atrial interval for enhanced visualization.
    - If `th_his` is None:
        - Only vertical dashed grey lines are drawn at the atrial and ventricular boundaries.
"""

def draw_his_boundaries(atr_t,ven_t, th_his=None,disp_atr_vent_boxes=False):
    
    
    if th_his is not None and not(disp_atr_vent_boxes):
        plt.plot([atr_t, ven_t], [th_his, th_his], color='red', linestyle='--')
        plt.plot([atr_t, ven_t], [-th_his, -th_his], color='red', linestyle='--')
        plt.plot([atr_t, atr_t], [th_his, -th_his],color='grey', linestyle=':');
        plt.plot([ven_t, ven_t], [th_his, -th_his],color='grey', linestyle=':');
        
    elif th_his is not None and disp_atr_vent_boxes:
        y_min, y_max = plt.gcf().gca().get_ylim()
        plt.plot([atr_t, ven_t], [th_his, th_his], color='red', linestyle='--')
        plt.plot([atr_t, ven_t], [-th_his, -th_his], color='red', linestyle='--')
        plt.plot([atr_t, atr_t], [th_his, -th_his],color='grey', linestyle=':');
        plt.plot([ven_t, ven_t], [th_his, -th_his],color='grey', linestyle=':');
    
        
        # plt.fill_between([0, atr_t], 0.5,max(0.6,y_max) , color=(0.8, 0.9, 1.0), alpha=0.3)  # Azzurro chiaro
        # plt.fill_between([0, atr_t], -0.5, min(-0.6,y_min), color=(0.8, 0.9, 1.0), alpha=0.3)  # Azzurro chiaro
        
        # Riempimento tra le due linee blu (tratteggiata e puntinata)
        plt.fill_between([0, atr_t], 0.3, 0, color=(0.7, 1.0, 0.7), alpha=0.3)  # Verde chiaro
        plt.fill_between([0, atr_t], -0.3, 0, color=(0.7, 1.0, 0.7), alpha=0.3)  # Verde chiaro

    else:
        plt.axvline(x=atr_t,color='grey', linestyle=':')
        plt.axvline(x=ven_t,color='grey', linestyle=':')