using Flux
include("movimentos.jl")

# Parametros do Q-Learning
α = 0.1 # Taxa de aprendizado
γ = 0.9 # Taxa de desconto
ϵ = 0.1 # Taxa de exploração



# 
function estado_tabuleiro(tabuleiro)
    return reshape(tabuleiro, 16)
end

# DEFINIR A ARQUITETURA DA REDE NEURAL USANDO O LIB Flux

criar_modelo() = Chain(
    Dense(16, 128, relu), # Camada oculta com 128 neuronios com ativação ReLu
    Dense(128, 64, relu), # Outra camada oculata com 64 neuronios
    Dense(64, 4)          # Camada de saída com 4 neuronios (Aqui são os movimentos)

)

# AQUI COMEÇA A IMPLEMENTAÃO DO CÓDIGO POR APREDIZADO POR REFORÇO
# Para treinar a IA, usarei uma abordagem chamada Q-Learning. A cada movimento, a IA
# Receberá uma recompensa baseada no aumento de pontuação, e essa pontuação será usada
# para ajustar a rede NEURAL


function jogar_partida!(modelo, tabuleiro, ϵ, pontuacao_ref)
    # ϵ: escolhe um movimento aleatorio ou o melhor movimento predito
    direcao = 1
    if rand() < ϵ
        direcao = rand(1:4)
    end

    # else
    #     estado = estado_tabuleiro(tabuleiro)
    #     q_valores = modelo(estado)
    #     movimento = argmax(q_valores) # escolhe o movimento com valor q
    # end
    # AQUI A REDE NEURAL VAI AGIR

    if direcao == 1
        mover_esquerda!(tabuleiro, pontuacao_ref)
    elseif direcao == 2
        mover_direita!(tabuleiro, pontuacao_ref)
    elseif direcao == 3
        mover_baixo!(tabuleiro, pontuacao_ref)
    elseif direcao == 4
        mover_cima!(tabuleiro, pontuacao_ref)
    end
end


function escolher_acao(Q,tabuleiro,ϵ)
    if rand() < ϵ
        return rand(1:4)
    end
end

function treinar_ia!(tabuleiro; epochs=1000, ϵ=0.1)
    modelo = criar_modelo()
    tabuleiro = iniciar_tabuleiro()
    pontuacao_ref = Ref(0)
    for epoch in 1:epochs
        k = 0
        while !fim_de_jogo(tabuleiro) && epoch == 1000
            println("ITERAÇOES: $k")
            println("PONTUACAO: $(pontuacao_ref[])")

            display(tabuleiro)
            estado_atual = estado_tabuleiro(tabuleiro)
            jogar_partida!(modelo, tabuleiro, ϵ, pontuacao_ref)

            # Agora fudeu... Aqui tem adicionar a lógica de recompensa 
            # e o ajuste do modelo
            # Q(s,a) <-- Q(s,a) + α * (r + γ  * maxQ(s', a) - Q(s,a))
            # Onde
            # s é o estado atual
            # α é a ação tomada
            # r é recompensa recebida
            # s' é o novo estado apos acao
            # α é a taxa de aprendizado
            # γ é o fator de desconto
            
            adiciona_peca_aleatoria!(tabuleiro)
            k+= 1
            sleep(0.2)
        end
    end
    display(tabuleiro)   
end

grade = iniciar_tabuleiro()
treinar_ia!(grade)