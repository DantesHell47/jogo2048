# INICIAZAR O TABULEIRO COM ZEROS 
# ADIOCIONAR DOIS TILEs ALETORIO 2 ou 4 EM UM POSICAo vazia
# IMPLEMENTAR AS FUNÇOES PARA MOVImentAR O JOGO
# CRIAR A FUNÇAO PARA COMBINAR O AS PEÇAS

mutable struct Jogo2048
    tabuleiro:: Matrix{Int}
    pontuacao:: Int
    movimentos:: Int
    historico:: Vector{Matrix{Int}}
end

function iniciar_tabuleiro()
    tabuleiro = zeros(Int, 4,4)
    # adicionar um numeros aletorios 2 ou 4 em posições vazias
    for _ in 1:2
        adiciona_peca_aleatoria!(tabuleiro)
    end
    return tabuleiro
end

function adiciona_peca_aleatoria!(tabuleiro)
    posicao_vazia = findall(x -> x == 0, tabuleiro)
    if !isempty(posicao_vazia)
        # escolhe uma posição vazia aleatória entre as vazias
        pos = rand(posicao_vazia)
        tabuleiro[pos] = rand() < 0.9 ? 2 : 4 # Não sei se exatamente essa a probabilidade.
    end
end

function combinar_pecas!(linha, pontuacao_ref)
    nova_linha = filter(!=(0), linha)
    for i in 1:length(nova_linha)-1
        if nova_linha[i] == nova_linha[i+1]
            nova_linha[i] *= 2
            pontuacao_ref[] += nova_linha[i]
            nova_linha[i + 1] = 0
        end
    end
    nova_linha = filter(!=(0), nova_linha)
    return vcat(nova_linha, zeros(Int, 4 - length(nova_linha)))
end

function combinar_pecas2!(linha)
    nova_linha = filter(!=(0), linha)
    i = 1
    while i <= length(nova_linha)-1
        if nova_linha[i] == nova_linha[i + 1]
            nova_linha[i] *= 2
            deleteat!(nova_linha, i + 1)
            push!(nova_linha, 0)
        end
        i += 1
    end
    return vcat(nova_linha, zeros(Int, 4 - length(nova_linha)))
end

function mover_esquerda!(tabuleiro, pontuacao_ref)
    for i in 1:4
        linha = tabuleiro[i, :]
        nova_linha = combinar_pecas!(linha, pontuacao_ref)
        tabuleiro[i, :] = nova_linha
    end
end

function mover_direita!(tabuleiro, pontuacao_ref)
    for i in 1:4
        linha = reverse(tabuleiro[i,:])
        nova_linha = combinar_pecas!(linha, pontuacao_ref)
        tabuleiro[i, :] = reverse!(nova_linha)
    end
end

function mover_cima!(tabuleiro, pontuacao_ref)
    for i in 1:4
        coluna = tabuleiro[:, i]
        nova_coluna = combinar_pecas!(coluna, pontuacao_ref)
        tabuleiro[:, i] = nova_coluna
    end
end

function mover_baixo!(tabuleiro, pontuacao_ref)
    for i in 1:4
        coluna = reverse(tabuleiro[:, i])
        nova_coluna = combinar_pecas!(coluna, pontuacao_ref)
        tabuleiro[:, i] = reverse!(nova_coluna)
    end
end

function movimentos!(tecla, tabuleiro,historico, pontuacao_ref, movimentos_ref)
    tabuleiro_antigo = copy(tabuleiro)

    if tecla == "w" || tecla == 1
        mover_cima!(tabuleiro, pontuacao_ref)
        movimentos_ref[]+= 1
        salvar_jogo!(tabuleiro, historico)

    elseif tecla == "s" || tecla == 2
        mover_baixo!(tabuleiro, pontuacao_ref)
        movimentos_ref[]+= 1
        salvar_jogo!(tabuleiro, historico)

    elseif tecla == "a" || tecla == 3
        mover_esquerda!(tabuleiro, pontuacao_ref)
        movimentos_ref[]+= 1
        salvar_jogo!(tabuleiro, historico)

    elseif tecla == "d" || tecla == 4
        mover_direita!(tabuleiro, pontuacao_ref)
        movimentos_ref[]+= 1
        salvar_jogo!(tabuleiro, historico)

    elseif tecla == "z"
        desfazer!(tabuleiro, historico)
    else
        println("Movimento inválido, Cuzão.")
    end
    
    if tabuleiro_antigo == tabuleiro
        movimentos_ref[] -= 1
        return tabuleiro = tabuleiro_antigo
    else
        return adiciona_peca_aleatoria!(tabuleiro)
    end

end

# AQUi SERÁ DEFINIDA A FUNÇÃO QUE VERIFICA O FIM DE JOGO 

function fim_de_jogo(tabuleiro)
    if any(tabuleiro .== 0)
        return false
    end
    # Verifica as linhas
    for i in 1:4, j in 1:3
        if tabuleiro[i, j] == tabuleiro[i, j + 1]
            return false
        end
    end
    # Verifica as coluna
    for i in 1:3, j in 1:4
        if tabuleiro[i, j] == tabuleiro[i + 1, j]
            return false
        end
    end
    return true
end

function salvar_jogo!(tabuleiro, historico)
    tabuleiro_antigo = copy(tabuleiro)
    push!(historico, tabuleiro_antigo)
    
end

function desfazer!(tabuleiro,historico)
    if !isempty(historico)
        tabuleiro .= pop!(historico)
    else
        println("Não há movimentos para desfazer.")
    end
end