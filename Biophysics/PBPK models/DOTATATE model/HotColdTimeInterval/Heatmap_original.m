paramSweep = data1.samples.generate{:,:};

hotAmountSteps = 20;
coldAmountSteps = 20;

hot = paramSweep(:,1);
cold = paramSweep(:,2);
interval = paramSweep(:,3);


Hot = reshape(hot, hotAmountSteps,hotAmountSteps,4);  % unit is nanomole
% Hot unit conversion to Activity = lambda*N
% A = Hot*1e-9(mol) * 6.022*1e23(#/mole) * lambda(1/min) * 1/60(min/sec) =
% Hot*0.72*1e9 (#/sec) = Hot*0.72 GBq
Hot = Hot * 72; % unit is GBq;
Cold = reshape(cold, coldAmountSteps,coldAmountSteps,4);


% Calculating total hot and total cold injected
Hot = Hot*5; %note that since we had 5 injections so we should *5
Cold = Cold*5; %note that since we had 5 injections so we should *5

Interval = reshape(interval, coldAmountSteps,coldAmountSteps,4); % we could
% also write: Interval = reshape(interval, hotAmountSteps,hotAmountSteps,4);


TINList = zeros(hotAmountSteps^2*4,1); % time integrated number of hot molecules
res = data1.results;

for i=1:length(res)
    TINList(i) = res(i).ScalarObservables{:,:};
end

TIN = reshape(TINList, coldAmountSteps,coldAmountSteps,4);
TIA = TIN * 7.23 * 1e-5;  % time integratede activity; A=N*lambda
% the unit of TIA is not #, it is nanomole. so it should be converted to #
% by multiplying at 6.023*10^23 * 10^(-9)
TIA = TIA * 6.023*1e23*1e-9;
TIA = TIA / 1e9; % the unit if TIA is now #bilion = GBq.sec





t = tiledlayout(2,2,'TileSpacing','Compact','Padding','Compact');
for i=1:4
    nexttile;
    contourf(Cold(:,:,i), Hot(:,:,i),TIA(:,:,i), 20);
    colormap("jet")
    caxis([0,9.5e5])
    %colorbar;
    title("time interval between injections: " + Interval(1,1,i) + " min", fontsize=14, FontWeight="normal");
    

end
cb = colorbar;
cb.Layout.Tile = 'east';
cb.Label.String = "TIA [GBq.second]";
cb.Label.FontSize = 10;
title(t, ["TIA in tumor: 5 equal injections"], fontsize=15)
xlabel(t, "total injected cold amount [nmol]", fontsize=15);
ylabel(t, "total injected activity [GBq]", fontsize=15);


