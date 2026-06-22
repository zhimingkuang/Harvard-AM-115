%adapted from https://tleise.people.amherst.edu/Math365Spring2014/Labs/DecryptionLab.pdf
%The exercise is originally from the book "Probabilty with Applications and
%R" by Robert Dobrow.

%Load the transition probability matrix M from all works of Jane Austen
%It is in counts thus not normalized as probability
load ./AustenCount.txt

%image(AustenCount'*256/max(AustenCount',[],'all'));colorbar
%xlabel('From (a-z and space)');ylabel('To (a-z and space)');title('Austen Count (normalized to max 256)')
%set(gca,'FontSize',16)
%It is a 27x27 matrix, representing a-z and space (the 27th element). All
%punctuations are removed.
%Some transition counts are zero. Add one to all to allow for some small
%probability of transition from any letter to any other letter. This is in practice important 
%Take the transpose so that M(i,j) is the number of times 
%of the jth letter followed by the ith letter. For example, M(2,1) is the
%number of times that letter a is followed by letter b.
M=AustenCount'+1;

%use log of transition probability. The log of the joint probability is
%the sum of the log probabilities of the individual steps.
logM=log(M); 

%Read in the encrypted message
text=char(importdata('EncryptedMessage.txt'));
display('---------------------');
display('Encrypted text');
display('---------------------');
for i=1:5
    display(text((i-1)*90+1:i*90));
end
display(text(451:end))
pause
%convert the characters into a numerical index
%a is 1, b is 2, ... z is 26, space is 27
for i=1:numel(text)
    index(i)=text(i)-'a'+1;
    if(index(i)==-64) %space
        index(i)=27;
    end
end

%initial mapping a->a b->b etc.
map_new=(1:27);
for i=1:numel(text)
    decoded_index(i)=map_new(index(i));
end

%score with the current mapping
score_old=compute_score(decoded_index,logM);
%Metropolis-Hastings algorithm for Markov Chain Monte Carlo (MCMC)
for iter=1:10000
    %space is not changed in this example so generate two random integers
    %between 1 and 26
    swap=randi([1 26],1,2);
    map_old=map_new;
    %switch the mapping for two random indices
    map_new(swap(1))=map_old(swap(2));
    map_new(swap(2))=map_old(swap(1));
    for i=1:numel(index);
        decoded_index(i)=map_new(index(i));
    end
    %score with the new mapping
    score_new=compute_score(decoded_index,logM);
    %decide whether to accept the new mapping map_new
    %or revert to the old one map_old
    if(rand>exp(score_new-score_old))
        %reject the proposal
        map_new=map_old;
    else
        %accept the proposal
        score_old=score_new;
    end
    %output the decoded text
    if(mod(iter,50)==0)
        decoded_text=char('a'+decoded_index-1);
        subs=find(decoded_index==27);
        decoded_text(subs)=' ';
        display('---------------------');
        display('Current decoded text');
        display('---------------------');
        for i=1:5
            display(decoded_text((i-1)*90+1:i*90));
        end
        display(decoded_text(451:end))
        
    end
end

%compute the probability that the current text is generated from this
%Markov chain based on the decode mapping.
%The log of the joint probability is the sum of the log probabilities of 
%the individual steps.
function score=compute_score(decoded_index,logM)
    score=0;
    for i=1:numel(decoded_index)-1
        %M(i,j) is the transition probabilty from j to i.
        score=score+logM(decoded_index(i+1),decoded_index(i));
    end
end

%actual text:
%from the very beginning from the first moment i may almost say of my acquaintance with you, 
%your manners, impressing me with the fullest belief of your arrogance, your conceit, and 
%your selfish disdain of the feelings of others, were such as to form the groundwork of 
%disapprobation on which succeeding events have built so immovable a dislike; and I had not 
%known you a month before I felt that you were the last man in the world whom I could ever 
%be prevailed on to marry.