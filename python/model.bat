@echo off
REM clean up to make sure model runs
REM del UY_do.out > null
REM del model.out > null
REM run QUAL2KW
call "C:\Users\kbranna\local_repos\pareto\qual2kw6.exe" > null
REM run python script to extract the model output
c:\miniconda3\python C:\Users\kbranna\local_repos\pareto\readq.py