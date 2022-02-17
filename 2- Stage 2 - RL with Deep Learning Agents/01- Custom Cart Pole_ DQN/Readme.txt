NOTE- Open the file CartPole_DQN


Continous Action Space Cart-Pole Environment with a policy gradient (PG) Agent 

Up until now we have used predefined environments, edited and modified the predefined environments.
In this module we go through the functions that are required to create a reinforcement learning evnironment in MATLAB.

The environment is a representation of what training ground for an agent. In order to navigate and get trained the agent needs to have information about -
State / Observation function is a representation of environment parameters that help identify its position.
Action function is to provide valid format of actions that an agent can take
Reward function is to provide an agent with the feedback of agent's action 
Step function if to guide agent in taking an action one at a time, and output the observations, rewards, and indicate whether the episode is complete
Reset function is to initialize an environment for the agent's training process and to clear some parameters from the previous training eposides
Environment input parameters that contains the environment constants
A simulation function that will execute the steps in environment as per the input parameters
Validation function to checking agent - environment interaction by calling the reset function and simulating the environment for one time step using step
Constructor function: A function that creates an instance of the class