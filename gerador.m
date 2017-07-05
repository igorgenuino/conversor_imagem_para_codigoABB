clear all, clc, close all
% Programa para gerar um arquivo txt somente com comando de linhas 
%de deslocamento a partir de um txt vindo de um svg
% a entrada deste programa dever ser um arquivo txt onde os simbolos 
%de curva, linha e movimento estejam identificados de acordo com o
% padrao a seguir **ESPACO*C*ESPACO**, ou seja ** C **
% Portanto é necessario fazer uma modificacão rapida no word ou onde quer
% que for para e substituir neste padrão. Alem disso, colocar letra maiuscula.


%% começo

Numero_retas = 10;

resultado_final = []; % resultado final - SVG vector Conterá os pontos que queremos
text = fileread('tester2d2.txt'); % importa texto svg limpo do jeito que precisamos

% acha as posições das letras do arquivo svg, o comando strfind encontra as
% posições das letras ao longo do texto
CC = strfind(text, ' C ');
MM = strfind(text, ' M ');
LL = strfind(text, ' L ');

% organiza as letras na ordem, o comando sort ordena em ordem crescente 
%os elementos dentro do veto desejado

posicoes_MLC = sort([CC MM LL]); 

% define o tamanho do vetor N que iremos utilizar 
N = length(posicoes_MLC);

%o for vai definir oque acontecera com cada letra letra C M ou L
for i = 1:N
    
    
    if i == N
        Texto_a_Inserir = text( posicoes_MLC(i):end);
    else
        % Começamos a montar o texto. Em um codigo SVG nunca o primeiro
        % é sempre M, então podemos começar aqui. Por exemplo: o
        % posicoes_MLC(1) é 4. 4 é a posição da primeira letra do nosso arquivo
        % de texto. O Texto_a_Inserir é formado pelo texto entre a posição a primeira
        % letra que esta na posição posicoes_MLC(1) e a segunda letra que esta na
        % posição posicoes_MLC(2). Assim, Texto_a_Inserir é M 0.00 0.00. M é o
        % posicoes_MLC(1) seguido pelo text ate o proximo posicoes_MLC.
        Texto_a_Inserir = text( posicoes_MLC(i):posicoes_MLC(i+1));
    end
    
    % Letra L e M nao são problemas. O C não é possivel de ser interpretado
    % pelo codigo o robo ABB como uma coordenadas_Cenada de forma direta. O vetor
    % achar_C é montado pelas posições do C que temos que modificar
    achar_C = strfind(Texto_a_Inserir,'C');
    
    % Cases
    if achar_C ~= 0
        % Sabemos pelo SVG que o é uma curva de bezier, entao vamos
        % trabalhar nisso. Pegamos os valores que tem apos a letra C que
        % sao as coordenadas_Cenadas de bezier. Transformamos em numeros.
        coordenadas_C = str2num(Texto_a_Inserir(1,achar_C+1:end));
        
        % Aqui colocamos os ultimos pontos antes do C como referencia de
        % inicio. Por exemplo, no primeiro C, o passo anterior foi mover
        % para M 483.0200 23.0100
        add2coordenadas_C = text(posicoes_MLC(i-1)+ 3:posicoes_MLC(i));
        add2coordenadas_C = str2num(add2coordenadas_C);
        add2coordenadas_C = [add2coordenadas_C(end-1) add2coordenadas_C(end)];
        
        % O NV é composto pelas coordenadas_Cenadas iniciais e pelas coordenadas_Cenadas do
        % SVG de bezier
        NV = [add2coordenadas_C coordenadas_C];
        
        % Chama a função bezier. NV(1) e NV(2) são os pontos iniciais.
        % Numero_retas é o numero de "retas" que se deseja transformar a curva. Px
        % e Py sao as coordenadas_Cenadas ponto a ponto das retas que formam a
        % curva
        [Px,Py] = bezier(NV(1),NV(2),NV(3),NV(4),NV(5),NV(6),NV(7),NV(8),Numero_retas);
        
        % Aqui transformamos os pontos Px e Py em texto com L (codigo de
        % reta. Assim, a curva de bezier foi transformada em Numero_retas retas,
        % trocando o codigo C para Numero_retas codigos L.
        for j = 1:size(Px,2)
            Texto_a_Inserir = num2str([Px(j) Py(j)]);
            %colocamos os Numero_retas coordenadas_Cenadas Px Py em forma de retas no
            %resultado_final.
            resultado_final = [resultado_final ' L ' Texto_a_Inserir ' ; ' ];
        end
        
       
    else
        %aqui é jogado no resultado_final (que é nosso vetor final) o Texto_a_Inserir.
        resultado_final = [resultado_final Texto_a_Inserir ' ; '];
        
    end
    
end

 %formamos o arquivo de texto com todas as coordenadas_Cenadas do desenho apenas
 %com M de mover e L de linha reta. Tudo pode ser interpretato pelo
 %programa da ABB.
fileID = fopen('teste1.txt','w');
fprintf(fileID, resultado_final)
fclose(fileID)
