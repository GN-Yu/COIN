for run = 1:obj_DM.runs
    motor_output(run,:) = OUTPUT.runs{run}.motor_output;
    state_feedback_output(run,:) = OUTPUT.runs{run}.state_feedback;
end
% figure
% plot(OUTPUT.weights*motor_output)
% hold on
% plot(OUTPUT.weights*state_feedback_output)
% legend('motor output','state feedback')

figure
plot(obj_DM.perturbations - OUTPUT.weights*motor_output)
grid on;
xlim([0,800]);
ylim([-1.2,1.2]);
legend("perturbations - motor output")