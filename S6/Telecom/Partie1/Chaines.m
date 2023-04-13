% Projet de Telecommunication : Etude de modulateurs bande de base
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all ; close all;

% Constantes
n_bits = 2000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 4. Etude de l'impact du bruit et du filtrage adapté, notion d'efficacité en puissance
% BRUIT
EbN0 = 0:8;

% Chaine 1 ---------------------------------------------------------
figure('name', 'Chaine 1')

Ts = Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr1 = ones(1, Ns);  % Reponse impulsionnelle du filtre de réception
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

% Sans bruit
    An = (2*bits - 1)';
    At = kron(An, [1, zeros(1, Ns-1)]); % Mapping

    x1 = filter(h, 1, At); % Mise en forme
    z1 = filter(hr1, 1, x1); % Filtre de réception

    echantillon = z1(n0:Ns:end); % Echantillonage
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB1 = sum(bits_sortie' ~= bits) / n_bits;

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z1,Ns,length(z1)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

    fprintf("TEB chaine 1 : " + TEB1 + "\n");

% Avec bruit
TEB1_bruit = zeros(1, length(EbN0));
z1_bruit = zeros(length(EbN0), length(z1));
for i = 1:length(EbN0)

    % Canal de propagation
    sigma2 = mean(x1.^2)*Ns/(2*10^(EbN0(i)/10));
    bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    r1 = x1 + bruit;

    z1 = filter(hr1, 1, r1);
    z1_bruit(i, :) = z1;

    echantillon = z1(n0:Ns:end);
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB1_bruit(i) = sum(bits_sortie' ~= bits) / n_bits;
end

    % Diagramme de l'oeil pour deux valeurs Eb / N0 différentes
    nexttile
    plot(reshape(z1_bruit(1, :),Ns,length(z1_bruit(1, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 1');
    xlabel('Temps (s)')

    nexttile
    plot(reshape(z1_bruit(9, :),Ns,length(z1_bruit(9, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 8');
    xlabel('Temps (s)')

    % TEB Obtenu et théorique
    TEB1_theorique = qfunc(sqrt(2*(10.^(EbN0/10))));
    semilogy(EbN0,TEB1_bruit)
    hold on
    semilogy(EbN0,TEB1_theorique)
    hold off
    title("Comparaison entre le TEB obtenu et le TEB théorique")
    legend("TEB obtenu","TEB théorique")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")

% Chaine 2 ---------------------------------------------------------
figure('name', 'Chaine 2')

Ts = Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr2 = ones(1, floor(Ns/2)); % Reponse impulsionnelle du filtre de réception
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

% Sans bruit
    % Mapping
    An = (2*bits - 1)';
    At = kron(An, [1, zeros(1, Ns-1)]);

    x2 = filter(h, 1, At);
    z2 = filter(hr2, 1, x2);

    echantillon = z2(n0:Ns:end);
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB2 = sum(bits_sortie' ~= bits) / n_bits;

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z2,Ns,length(z2)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

    fprintf("TEB chaine 2 : " + TEB2 + "\n");

% Avec bruit
TEB2_bruit = zeros(1, length(EbN0));
z2_bruit = zeros(length(EbN0), length(z2));
for i = 1:length(EbN0)

    % Canal de propagation
    sigma2 = mean(x2.^2)*Ns/(2*10^(EbN0(i)/10));
    bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    r2 = x2 + bruit;

    z2 = filter(hr2, 1, r2);
    z2_bruit(i, :) = z2;

    echantillon = z2(n0:Ns:end);
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB2_bruit(i) = sum(bits_sortie' ~= bits) / n_bits;
end

    % Diagramme de l'oeil pour deux valeurs Eb / N0 différentes
    nexttile
    plot(reshape(z2_bruit(1, :),Ns,length(z2_bruit(1, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 1');
    xlabel('Temps (s)')

    nexttile
    plot(reshape(z2_bruit(9, :),Ns,length(z2_bruit(9, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 8');
    xlabel('Temps (s)')

    % TEB Obtenu et théorique
    TEB2_theorique = qfunc(sqrt(2*(10.^(EbN0/10))));
    semilogy(EbN0,TEB2_bruit)
    hold on
    semilogy(EbN0,TEB2_theorique)
    hold off
    title("Comparaison entre le TEB obtenu et le TEB théorique")
    legend("TEB obtenu","TEB théorique")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")
   

% Chaine 3 ---------------------------------------------------------
figure('name', 'Chaine 3')

Ts = 2 * Tb;        % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr3 = ones(1, Ns); % Reponse impulsionnelle du filtre de réception
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

% Sans bruit
    % Mapping
    LUT = [-3, -1, 3, 1];
    An = LUT(1+bi2de(reshape(bits, n_bits/2, 2), 'left-msb'));
    At = kron(An, [1, zeros(1, Ns-1)]);

    x3 = filter(h, 1, At);
    z3 = filter(hr2, 1, x3);

    echantillon = z3(n0:Ns:end);
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB3 = sum(bits_sortie' ~= bits) / n_bits;

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z3,Ns,length(z3)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

    fprintf("TEB chaine 3 : " + TEB2 + "\n");

% Avec bruit
TEB3_bruit = zeros(1, length(EbN0));
z3_bruit = zeros(length(EbN0), length(z3));
for i = 1:length(EbN0)

    % Canal de propagation
    sigma2 = mean(x3.^2)*Ns/(4*10^(EbN0(i)/10));
    bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    r3 = x3 + bruit;

    z3 = filter(hr3, 1, r3);
    z3_bruit(i, :) = z3;

    echantillon = z3(n0:Ns:end);
    bits_sortie = (sign(echantillon) + 1) / 2;
    TEB3_bruit(i) = sum(bits_sortie' ~= bits) / n_bits;
end

    % Diagramme de l'oeil pour deux valeurs Eb/N0 différentes
    nexttile
    plot(reshape(z3_bruit(1, :),Ns,length(z3_bruit(1, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 1');
    xlabel('Temps (s)')

    nexttile
    plot(reshape(z3_bruit(9, :),Ns,length(z3_bruit(9, :))/Ns));
    title('Diagramme de l''oeil pour Eb/N0 = 8');
    xlabel('Temps (s)')

    % TEB Obtenu et théorique
    TEB3_theorique = qfunc(sqrt(2*(10.^(EbN0/10))));
    semilogy(EbN0,TEB3_bruit)
    hold on
    semilogy(EbN0,TEB3_theorique)
    hold off
    title("Comparaison entre le TEB obtenu et le TEB théorique")
    legend("TEB obtenu","TEB théorique")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")



% 4.2 Comparaison des chaines de transmission implantées
figure('name', "Comparaison des chaines de transmission implantées")

    % TEB des chaines 1 et 2
    plot(TEB1_bruit)
    hold on
    plot(TEB2_bruit)
    hold off
    title("Comparaison entre le TEB des chaines 1 et 2")
    legend("Chaine 1","Chaine 2")
    ylabel("TEB")

% Efficacité de puissance chaines 1 et 2


    % TEB des chaines 1 et 3
    plot(TEB1_bruit)
    hold on
    plot(TEB3_bruit)
    hold off
    title("Comparaison entre le TEB des chaines 1 et 2")
    legend("Chaine 1","Chaine 2")
    ylabel("TEB")

% Efficacité de puissance chaines 1 et 3



