function stopexecution()
    global stopExecution;
    stopExecution = true; % Set flag to stop execution
    uiresume(gcbf); % Resume the paused execution
end