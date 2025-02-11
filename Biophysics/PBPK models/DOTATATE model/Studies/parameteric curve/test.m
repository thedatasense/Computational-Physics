
paramSweep = data1.samples.generate{:,:};


res = data1.results;
numberOfOrgansforTIN = 5;



TINValues = zeros(length(res), numberOfOrgansforTIN);
for i=1:length(res)
    TINValues(i,:) = res(i).ScalarObservables{:,:};
end


NTIA = TINValues./TINValues(1,:);

plot(NTIA(2:end,end), NTIA(2:end,1:4), "LineWidth",4)
legend(["Spleen", "Kidney", "Liver", "RedMarrow"])
grid("on")

xlabel("NTIA Tumor")
ylabel("NTIA organ at risk")