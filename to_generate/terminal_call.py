from Meta_Driver import vary_params
import numpy

if __name__ == "__main__":
    #this is what gets editted most of the time -- also potentially writer
    dist_vec=[500]#[100, 1000]
    m_prop_vec=numpy.linspace(.05, .95, 10)#numpy.linspace(.05, .95, 19) #.05, .1, .15, ... , .95; OR: intervals of .1
    RB_time_vec=[6]#[1.5, 3, 6] #hrs
    num_sims=1000
    max_m_vec=[0.054]#[0.027,0.054]
    vary_params(dist_vec, m_prop_vec, RB_time_vec, num_sims, max_m_vec)