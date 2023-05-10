figure;

% Loop over the figures
for i = 1:10
    % Create a subplot for each figure
    subplot(5, 2, i);
    
    % Load and display the i-th figure
    img = imread(fullfile('.', 'figureoutput_COIN', ['figure' num2str(i) '.png']));
    imshow(img);
    
    title(['Figure ', num2str(i)]);
end