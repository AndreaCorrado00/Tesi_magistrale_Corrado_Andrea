function App=compute_pp_amplitude(example_rov,fc)

example_rov=example_rov(round(fc*0.15):round(0.65*fc));
App=max(example_rov)-abs(min(example_rov));
