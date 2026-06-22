%Modified and verified from Chatgpt generated code.
seq=fileread("weather_markov_sequence.txt");
% Map states to numbers
% H = 1, C = 2
num_seq = zeros(1,length(seq));
num_seq(seq == 'H') = 1;
num_seq(seq == 'C') = 2;

% Initialize transition count matrix
T = zeros(2,2);

for t = 1:length(num_seq)-1
    j = num_seq(t);
    i = num_seq(t+1);
    T(i,j) = T(i,j) + 1;
end

% Display matrix
disp('Transition Count Matrix:')
disp('      From H     From C')
disp(['To H   ', num2str(T(1,1)), '       ', num2str(T(1,2))])
disp(['To C   ', num2str(T(2,1)), '       ', num2str(T(2,2))])

%Bootstrap
B = 5000; %number of bootstrap trials

% Build vectors of next-states for each from-state
nextFromH = num_seq(find(num_seq(1:end-1)==1)+1);
nextFromC = num_seq(find(num_seq(1:end-1)==2)+1);

NH=length(nextFromH); %number of cases starting from the Hot state
NC=length(nextFromC); %number of cases starting from the Cold state

%store the results from the bootstrap
pHH_boot = zeros(B,1);
pCH_boot = zeros(B,1);

for b = 1:B
    sampH = nextFromH(randi(NH, 1, NH)); %randomly select outcome
    sampC = nextFromC(randi(NC, 1, NC));

    pHH_boot(b) = mean(sampH == 1);
    pCH_boot(b) = mean(sampC == 1);
end

ciHH = quantile(pHH_boot, [0.025 0.975]);
ciCH = quantile(pCH_boot, [0.025 0.975]);

fprintf('Bootstrap 95%% CI p(H->H): [%.4f, %.4f]\n', ciHH(1), ciHH(2));
fprintf('Bootstrap 95%% CI p(C->H): [%.4f, %.4f]\n', ciCH(1), ciCH(2));