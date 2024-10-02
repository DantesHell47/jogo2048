include("movimentos.jl")

function play_game()
    grade = iniciar_tabuleiro()
    pontuacao_ref = Ref(0)
    movimentos_ref = Ref(0)
    historico = [grade]

    while !fim_de_jogo(grade)
        println("GRADE ANTERIOR $(length(historico))")
        display(historico)
        println()
        println("PONTUAÇAO: $(pontuacao_ref[])")
        print("MOVIMENTOS: $(movimentos_ref[])")
        println()
        display(grade)
        println()
        tecla = readline()

        # movimento_valido(tecla, grade,historico, pontuacao_ref, movimentos_ref)
        movimentos!(tecla, grade, historico,pontuacao_ref, movimentos_ref)
        # adiciona_peca_aleatoria!(grade)
        popfirst!(historico)
    end
    println("PERDEU, cuzinho de aperta linguiça!!")
end
play_game()