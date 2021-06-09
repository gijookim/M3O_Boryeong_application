### M3O application on Boryeong Reservoir
This repository is an application of M3O Matlab toolbox for designing optimal operations of multipurpose water reservoir systems. This application of the M3O toolbox on Boryeong Dam located in South Korea aims to derive optimal solutions using DDP-Perfect, DDP-Average, SDP, and three EMODPS models each with different number of parameters and shapes of approximating functions. Then their performances are measured under discrete set of inflow series using K-fold Cross Validation method (K=4). Also, the effect of incorporation of a zone-based hedging rule is also explored during simulation.

In order to replicate the steps of the analysis on Boryeong Reservoir, download the data files from on the following Dataset on Mendeley Data (http://dx.doi.org/10.17632/9ntcdscwpd.3) and copy the files into /sim/data in this repository, which is currently empty.
After that, run the main_script.m file by carefully following the instructions given inside the code file. 

This code is used to generate the dataset used to generate figures in: 
Kim, G. J., & Kim, Y. O. (2021). How does the coupling of real-world policies with optimization models expand the practicality of solutions in reservoir operation problems?. Water Resources Management, 1-17. https://link.springer.com/article/10.1007/s11269-021-02862-y

Informal Erratums to the article is attached in "Informal_Erratum.pdf." Please refer to this file as the informal Erratum to the paper Kim and Kim (2021), mentioned above.

The description of the original M3O toolbox can be found from https://github.com/mxgiuliani00/M3O-Multi-Objective-Optimal-Operations.
Please refer to the original Readme file for more detailed explanations regarding methods using M3O toolbox. 



#### Copyright of the Original M3O Toolbox
Copyright 2016 NRM group - Politecnico di Milano

Developers: Matteo Giuliani, Yu Li, Andrea Cominola, Simona Denaro, Emanuele Mason, Andrea Castelletti, Francesca Pianosi, Daniela Anghileri, Stefano Galelli.

M3O is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

The code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with M3O. If not, see http://www.gnu.org/licenses/licenses.en.html.
