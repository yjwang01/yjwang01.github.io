@echo off

rd /S /q public
rd /S /q resources

git add .
@REM set /p var= "Please input commit message: "

@REM git commit -m "%var%"
git commit
git push origin master
