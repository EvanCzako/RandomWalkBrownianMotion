function numEnclosedParticles = randomWalk(sizeX,sizeY,numParticles,numIterations,stepTime,circleRadius)

    % Simulates a 2D random walk of particles and records the number of
    % particles enclosed in a circle centered at the origin of the
    % particles. The particles originate at the center of the displayed
    % image.
    % sizeX and sizeY indicate the dimensions of the iamge to be displayed.
    % numParticles indicates the number of particles to be included in the
    % simulation. numIterations indicates the number of random steps to be
    % included in the simulation. stepTime refers to the amount of time to
    % elapse between random steps (in seconds). circleRadius indicates the
    % radius of the circle of interest. numEnclosedParticles (output) is a
    % record of the number of particles enclosed within the circle at each
    % step of the random walk.
    %
    % See example below for demonstration. This function is intended to
    % assist with the visualization of Brownian motion.
    %
    %
    % %% EXAMPLE:
    %     % In this example, we run the random walk simulation over a 100x100 grid
    %     % with 50 particles. The simulation will run for 1000 steps, with 0.01
    %     % seconds between each step. The radius of the circle of interest is 10,
    %     % so the output list will specify the number of particles that are enclosed
    %     % by the circle at each step of the simulation.
    % 
    %     list1 = randomWalk(100,100,50,1000,0.01,10);
    %     plot(list1);
    %
    %
    %
    % Evan Czako, 3.24.2021.
    

    points = ones(numParticles,1)*[ceil(sizeY/2),ceil(sizeX/2)];
    livePoints = points;

    circleCenter = [ceil(sizeY/2),ceil(sizeX/2)];
    numEnclosedParticles = zeros(numIterations,1);

    moveMat = round(rand(numParticles,1));
    moveMat = [moveMat double(not(moveMat))];
    randNeg = 3-2*round((rand(numParticles,2)+1));
    moveMat = moveMat.*randNeg;

    testMat = zeros(sizeY,sizeX);

    for it = 1:numIterations


        indices = sub2ind(size(testMat),livePoints(:,1),livePoints(:,2));
        testMat(indices) = 1;
        imagesc(testMat);
        title(strcat('Step#:',{' '},string(it)));

        offset = points - circleCenter;
        distances = sqrt(offset(:,1).^2+offset(:,2).^2);
        count = sum(double(distances<=circleRadius));
        numEnclosedParticles(it) = count;

        testMat(:) = 0;
        pause(stepTime);
        points = points+moveMat;
        livePoints = points;

        xMin = livePoints(:,2) > 0;
        xMin = double(xMin);
        xMin(xMin==0) = nan;
        yMin = livePoints(:,1) > 0;
        yMin = double(yMin);
        yMin(yMin==0) = nan;
        xMax = livePoints(:,2) <= sizeX;
        xMax = double(xMax);
        xMax(xMax==0) = nan;
        yMax = livePoints(:,1) <= sizeY;
        yMax = double(yMax);
        yMax(yMax==0) = nan;
        livePoints = livePoints.*[yMin xMin].*[yMax xMax];  
        livePoints(any(isnan(livePoints), 2), :) = [];

        moveMat = round(rand(numParticles,1));
        moveMat = [moveMat double(not(moveMat))];
        randNeg = 3-2*round((rand(numParticles,2)+1));
        moveMat = moveMat.*randNeg;
        
    end

end

