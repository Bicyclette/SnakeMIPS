#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

# Score du joueur

game_over:	.asciiz "GAME OVER\n"
score:		.asciiz "Votre serpent a mangé "
bonbon:		.asciiz " bonbon !"
bonbons:	.asciiz " bonbons !"

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:

	##### prologue #####
		subu $sp, $sp, 12
		sw $a0, 8($sp)
		sw $t0, 4($sp)
		sw $ra, 0($sp)

	##### corps #####

		##### on charge dans $t0 la direction précédente du serpent
		lw $t0, snakeDir
		
		##### on cherche à connaître la valeur contenue dans $t0 avec 4 tests (haut, droite, bas, gauche)
		##### puis en fonction de $a0 (la nouvelle direction demandée par l'utilisateur) on détermine
		##### quelle nouvelle valeur à mettre dans snakeDir par le biais de $t0
		haut:
			bne $t0, 0, droite

			set_haut0:
				bne $a0, 0, set_droite0
				j finMajDirection
			set_droite0:
				bne $a0, 1, set_bas0
				sw $a0, snakeDir
				j finMajDirection
			set_bas0:
				bne $a0, 2, set_gauche0
				j finMajDirection
			set_gauche0:
				bne $a0, 3, erreur
				sw $a0, snakeDir
				j finMajDirection
		droite:
			bne $t0, 1, bas

			set_haut1:
				bne $a0, 0, set_droite1
				sw $a0, snakeDir
				j finMajDirection
			set_droite1:
				bne $a0, 1, set_bas1
				j finMajDirection
			set_bas1:
				bne $a0, 2, set_gauche1
				sw $a0, snakeDir
				j finMajDirection
			set_gauche1:
				bne $a0, 3, erreur
				j finMajDirection
		bas:
			bne $t0, 2, gauche

			set_haut2:
				bne $a0, 0, set_droite2
				j finMajDirection
			set_droite2:
				bne $a0, 1, set_bas2
				sw $a0, snakeDir
				j finMajDirection
			set_bas2:
				bne $a0, 2, set_gauche2
				j finMajDirection
			set_gauche2:
				bne $a0, 3, erreur
				sw $a0, snakeDir
				j finMajDirection
		gauche:
			set_haut3:
				bne $a0, 0, set_droite3
				sw $a0, snakeDir
				j finMajDirection
			set_droite3:
				bne $a0, 1, set_bas3
				j finMajDirection
			set_bas3:
				bne $a0, 2, set_gauche3
				sw $a0, snakeDir
				j finMajDirection
			set_gauche3:
				bne $a0, 3, erreur
				j finMajDirection
		erreur:
			j finMajDirection

		finMajDirection:

	##### epilogue #####
		lw $a0, 8($sp)
		lw $t0, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 12
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

	##### prologue #####
		subu $sp, $sp, 48
		sw $s0, 44($sp)
		sw $s1, 40($sp)
		sw $s2, 36($sp)
		sw $s3, 32($sp)
		sw $s4, 28($sp)
		sw $s5, 24($sp)
		sw $s6, 20($sp)
		sw $s7, 16($sp)
		sw $t0, 12($sp)
		sw $t1, 8($sp)
		sw $t2, 4($sp)
		sw $ra, 0($sp)

	##### corps #####
		jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt
		
		has_eaten_candy:
				lw $s0, candy
				lw $s1, candy + 4
				lw $s2, snakePosX
				lw $s3, snakePosY
				lw $s4, numObstacles
				la $s5, obstaclesPosX
				la $s6, obstaclesPosY
				li $s7, 4

				bne $s2, $s0 fin_update
				bne $s3, $s1 fin_update
				
				##### on lit le code ci-dessous
				##### si la tête du serpent est sur le bonbon
				
				jal newRandomObjectPosition
				sw $v0, candy
				sw $v1, candy + 4
				jal newRandomObjectPosition
				mul $t0, $s4, $s7
				addu $t1, $s5, $t0
				sw $v0, 0($t1)
				addu $t1, $s6, $t0
				sw $v1, 0($t1)

				##### on incrémente la valeur du nombre d'obstacles contenus dans le jeu
				addu $s4, $s4, 1
				sw $s4, numObstacles

				##### on incrémente le score du joueur
				lw $t2, scoreJeu
				addi $t2, $t2, 1
				sw $t2, scoreJeu

				jal snakeWillGrowStrong

		fin_update:

	##### epilogue #####
		lw $s0, 44($sp)
		lw $s1, 40($sp)
		lw $s2, 36($sp)
		lw $s3, 32($sp)
		lw $s4, 28($sp)
		lw $s5, 24($sp)
		lw $s6, 20($sp)
		lw $s7, 16($sp)
		lw $t0, 12($sp)
		lw $t1, 8($sp)
		lw $t2, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 48
jr $ra

hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt:

	##### prologue #####
		subu $sp, $sp, 28
		sw $s0, 24($sp)
		sw $s1, 20($sp)
		sw $s2, 16($sp)
		sw $s3, 12($sp)
		sw $s4, 8($sp)
		sw $s5, 4($sp)
		sw $ra, 0($sp)

	##### corps #####

		la $s0, snakePosX
		la $s1, snakePosY
		lw $s2, snakeDir
		lw $s3, tailleSnake

		##### on charge les coordonnées de la tête du serpent
		lw $s4, 0($s0)
		lw $s5, 0($s1)

		##### selon l'endroit ou le serpent se dirige ($s2) et sa taille ($s3)
		##### on fait bouger le serpent en fonction
		direction_haut:
				bne $s2, 0, direction_droite
				##### le serpent se déplace en haut, on vérifie sa taille
				bne $s3, 1, big_snake_haut
				addu $s4, $s4, 1
				sw $s4, 0($s0)
				sw $s5, 0($s1)
				j fin_direction

				big_snake_haut:
						jal decalageDroite
						addu $s4, $s4, 1
						sw $s4, 0($s0)
						sw $s5, 0($s1)
						j fin_direction
						
		direction_droite:
				bne $s2, 1, direction_bas
				##### le serpent se déplace vers la droite, on vérifie sa taille
				bne $s3, 1, big_snake_droite
				addu $s5, $s5, 1
				sw $s5, 0($s1)
				sw $s4, 0($s0)
				j fin_direction

				big_snake_droite:
						jal decalageDroite
						addu $s5, $s5, 1
						sw $s5, 0($s1)
						sw $s4, 0($s0)
						j fin_direction
		direction_bas:
				bne $s2, 2, direction_gauche
				##### le serpent se déplace en bas, on vérifie sa taille
				bne $s3, 1, big_snake_bas
				subu $s4, $s4, 1
				sw $s4, 0($s0)
				sw $s5, 0($s1)
				j fin_direction

				big_snake_bas:
						jal decalageDroite
						subu $s4, $s4, 1
						sw $s4, 0($s0)
						sw $s5, 0($s1)
						j fin_direction
		direction_gauche:
				##### le serpent se déplace vers la gauche, on vérifie sa taille
				bne $s3, 1, big_snake_gauche
				subu $s5, $s5, 1
				sw $s5, 0($s1)
				sw $s4, 0($s0)
				j fin_direction

				big_snake_gauche:
						jal decalageDroite
						subu $s5, $s5, 1
						sw $s5, 0($s1)
						sw $s4, 0($s0)
						j fin_direction

		fin_direction:

	##### epilogue #####
		lw $s0, 24($sp)
		lw $s1, 20($sp)
		lw $s2, 16($sp)
		lw $s3, 12($sp)
		lw $s4, 8($sp)
		lw $s5, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 28

jr $ra

decalageDroite:

	##### prologue #####
		subu $sp, $sp, 32
		sw $s0, 28($sp)
		sw $s1, 24($sp)
		sw $s2, 20($sp)
		sw $s3, 16($sp)
		sw $s4, 12($sp)
		sw $s5, 8($sp)
		sw $s6, 4($sp)
		sw $ra, 0($sp)

	##### corps #####

		##### $s3 => le décalage en octets à partir du début des tableaux
		##### snakePosX et snakePosY pour arriver à la fin de ceux-ci
		la $s0, snakePosX
		la $s1, snakePosY
		lw $s2, tailleSnake
		subu $s2, $s2, 1
		li $s4, 4
		mul $s3, $s2, $s4
		
		startCheat:
			blt $s3, $zero, endCheat
			add $s5, $s0, $s3
			lw $s6, 0($s5)
			sw $s6, 4($s5)
			add $s5, $s1, $s3
			lw $s6, 0($s5)
			sw $s6, 4($s5)
			subu $s3, $s3, 4
			j startCheat
		endCheat:

	##### epilogue #####
		lw $s0, 28($sp)
		lw $s1, 24($sp)
		lw $s2, 20($sp)
		lw $s3, 16($sp)
		lw $s4, 12($sp)
		lw $s5, 8($sp)
		lw $s6, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 32

jr $ra

snakeWillGrowStrong:

	##### prologue #####
		subu $sp, $sp, 60
		sw $s0, 56($sp)
		sw $s1, 52($sp)
		sw $s2, 48($sp)
		sw $s3, 44($sp)
		sw $s4, 40($sp)
		sw $s5, 36($sp)
		sw $s6, 32($sp)
		sw $s7, 28($sp)
		sw $t0, 24($sp)
		sw $t1, 20($sp)
		sw $t2, 16($sp)
		sw $t3, 12($sp)
		sw $t4, 8($sp)
		sw $t5, 4($sp)
		sw $ra, 0($sp)

	##### corps #####
		lw $s0, tailleSnake
		lw $s1, snakeDir
		lw $s2, lastSnakePiece
		lw $s3, lastSnakePiece + 4
		la $s4, snakePosX
		la $s5, snakePosY
		lw $s6, tailleGrille
		li $s7, 4

		##### Si taille du serpent = 1
		##### on prend sa direction comme référence
		##### pour savoir si le bout de queue à rajouter
		##### aura un incrément sur les X ou Y
		taille1: bne $s0, 1, sup2
			expand_bas: bne $s1, 0, expand_gauche
					##### $t0 => décalage en octets depuis le début des
					##### tableaux snakePosX et snakePosY pour arriver
					##### à la fin de ces derniers
					mul $t0, $s0, $s7
					##### $t1 l'adresse de fin des tableaux
					##### snakePosX ($s4) et snakePosY ($s5) + 4
					addu $t1, $s4, $t0
					lw $t3, snakePosX
					addu $t3, $t3, 1
					sw $t3, 0($t1)

					j finGrow

			expand_gauche: bne $s1, 1, expand_haut
					##### $t0 => décalage en octets depuis le début des
					##### tableaux snakePosX et snakePosY pour arriver
					##### à la fin de ces derniers
					mul $t0, $s0, $s7
					##### $t1 l'adresse de fin des tableaux
					##### snakePosX ($s4) et snakePosY ($s5)
					addu $t1, $s5, $t0
					lw $t2, snakePosY
					subu $t2, $t2, 1
					sw $t2, 0($t1)

					j finGrow

			expand_haut: bne $s1, 2, expand_droite
					##### $t0 => décalage en octets depuis le début des
					##### tableaux snakePosX et snakePosY pour arriver
					##### à la fin de ces derniers
					mul $t0, $s0, $s7
					##### $t1 l'adresse de fin des tableaux
					##### snakePosX ($s4) et snakePosY ($s5)
					addu $t1, $s4, $t0
					lw $t3, snakePosX
					subu $t3, $t3, 1
					sw $t3, 0($t1)

					j finGrow

			expand_droite:
					##### $t0 => décalage en octets depuis le début des
					##### tableaux snakePosX et snakePosY pour arriver
					##### à la fin de ces derniers
					mul $t0, $s0, $s7
					##### $t1 l'adresse de fin des tableaux
					##### snakePosX et snakePosY
					addu $t1, $s5, $t0
					lw $t2, snakePosY
					addu $t2, $t2, 1
					sw $t2, 0($t1)

					j finGrow
					
		##### sinon (taille > 2)
		##### on compare les valeurs en X et Y
		##### pour le bout de queue et le bloc avant le bout de queue
		##### la valeur redondante (soit X soit Y) indiquera sur quelle coordonnée
		##### on devra incrémenter la valeur du bout de la queue du serpent
		##### pour créer le nouveau bloc qui s'ajoutera au bout de la queue du serpent
		sup2:
			subu $t0, $s0, 2
			li $t1, 4
			##### $t2 => décalage en octets pour arriver sur
			##### l'avant dernier élément des tableaux snakePosX et snakePosY
			mul $t2, $t0, $t1
			##### on décale les adresses de ces deux tableaux
			addu $t0, $s4, $t2
			addu $t1, $s5, $t2
			##### on récupère la valeur à ces endroits
			lw $t2, 0($t0)
			lw $t3, 0($t1)
			##### on récupère aussi les coordonnées du bout de la queue
			lw $t4, 4($t0)
			lw $t5, 4($t1)
			##### puis on compare
			incrX: bne $t2, $t4, incrY
				tete_droite: bne $s1, 1, tete_gauche
						subu $t5, $t5, 1
						sw $t4, 8($t0)
						sw $t5, 8($t1)
						j finGrow
				tete_gauche:
						addu $t5, $t5, 1
						sw $t4, 8($t0)
						sw $t5, 8($t0)
						j finGrow
			incrY:
				tete_haut: bne $s1, 0, tete_bas
						addu $t4, $t4, 1
						sw $t4, 8($t0)
						sw $t5, 8($t1)
						j finGrow
				tete_bas:
						subu $t4, $t4, 1
						sw $t4, 8($t0)
						sw $t5, 8($t1)
						j finGrow
				
		finGrow:
			addu $s0, $s0, 1
			sw $s0, tailleSnake

	##### epilogue #####
		lw $s0, 56($sp)
		lw $s1, 52($sp)
		lw $s2, 48($sp)
		lw $s3, 44($sp)
		lw $s4, 40($sp)
		lw $s5, 36($sp)
		lw $s6, 32($sp)
		lw $s7, 28($sp)
		lw $t0, 24($sp)
		lw $t1, 20($sp)
		lw $t2, 16($sp)
		lw $t3, 12($sp)
		lw $t4, 8($sp)
		lw $t5, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 60

jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:

	##### prologue #####
		subu $sp, $sp, 68
		sw $s0, 64($sp)
		sw $s1, 60($sp)
		sw $s2, 56($sp)
		sw $s3, 52($sp)
		sw $s4, 48($sp)
		sw $s5, 44($sp)
		sw $s6, 40($sp)
		sw $s7, 36($sp)
		sw $t0, 32($sp)
		sw $t1, 28($sp)
		sw $t2, 24($sp)
		sw $t3, 20($sp)
		sw $t4, 16($sp)
		sw $t5, 12($sp)
		sw $t6, 8($sp)
		sw $t7, 4($sp)
		sw $ra, 0($sp)
		
	##### corps #####
		lw $s0, snakePosX
		lw $s1, snakePosY
		la $s2, obstaclesPosX
		la $s3, obstaclesPosY
		la $s4, snakePosX
		la $s5, snakePosY
		lw $s6, tailleGrille
		
		lw $s7, numObstacles

		li $t0, 0
		li $t4, 4

		##### bords du jeu
		beq $s0, $s6, finJeu
		blt $s0, $zero, finJeu
		beq $s1, $s6, finJeu
		blt $s1, $zero, finJeu

		##### collision avec un obstacle
		whileOBST: beq $t0, $s7, finWhileOBST
			##### $t1 => le décalage à effectuer dans les tableaux
			##### obstaclesPosX ($s2) et obstaclesPosY ($s3)
			mul $t1, $t0, $t4
			##### $t2 adresse actuelle dans tableau des X pour les obstacles
			##### $t3 adresse actuelle dans tableau des Y pour les obstacles
			add $t2, $t1, $s2
			add $t3, $t1, $s3
			##### on récupère les valeurs à ces adresses
			lw $t5, 0($t2)
			lw $t6, 0($t3)

			##### puis on les compare avec la position de la tête du serpent
			verifX: beq $s0, $t5, verifY
				j notMatched
			verifY: beq $s1, $t6, finJeu
			notMatched:
				addu $t0, $t0, 1
				b whileOBST
		finWhileOBST:

		##### collision avec le corps du serpent (le code suivant est lu si tailleSnake > 1)
			li $t0, 1
			lw $t7, tailleSnake

			beq $t7, 1, noTimeToLoose
			
			subu $t7, $t7, 1

			forBODY: beq $t0, $t7, finForBODY
				##### $t1 => le décalage à effectuer dans les tableaux
				##### obstaclesPosX ($s2) et obstaclesPosY ($s3)
				mul $t1, $t0, $t4
				##### $t2 adresse actuelle dans tableau des X pour le corps du serpent
				##### $t3 adresse actuelle dans tableau des Y pour le corps du serpent
				addu $t2, $t1, $s4
				addu $t3, $t1, $s5
				##### on récupère les valeurs à ces adresses
				lw $t5, 0($t2)
				lw $t6, 0($t3)

				##### puis on les compare avec la position de la tête du serpent
				verifXbody: beq $s0, $t5, verifYbody
					j noCollide
				verifYbody: beq $s1, $t6, finJeu
				noCollide:
					addu $t0, $t0, 1
					b forBODY
			finForBODY:

			noTimeToLoose:

		continueJeu:
			li $v0, 0
			j epilogue
		finJeu:
			li $v0, 1

		epilogue:

	##### epilogue #####
		lw $s0, 64($sp)
		lw $s1, 60($sp)
		lw $s2, 56($sp)
		lw $s3, 52($sp)
		lw $s4, 48($sp)
		lw $s5, 44($sp)
		lw $s6, 40($sp)
		lw $s7, 36($sp)
		lw $t0, 32($sp)
		lw $t1, 28($sp)
		lw $t2, 24($sp)
		lw $t3, 20($sp)
		lw $t4, 16($sp)
		lw $t5, 12($sp)
		lw $t6, 8($sp)
		lw $t7, 4($sp)
		lw $ra, 0($sp)
		addu $sp, $sp, 68

jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

	##### prologue #####
	subu $sp, $sp, 8
	sw $t0, 4($sp)
	sw $ra, 0($sp)

	##### corps #####
	li $v0, 4
	lw $t0, scoreJeu
	
	zero: bne $t0, $zero, supZ
		la $a0, game_over
		syscall
		la $a0, score
		syscall
		li $v0, 1
		li $a0, 0
		syscall
		li $v0, 4
		la $a0, bonbons
		syscall
		j finStats

	supZ: bne $t0, 1, sup1
		la $a0, game_over
		syscall
		la $a0, score
		syscall
		li $v0, 1
		li $a0, 1
		syscall
		li $v0, 4
		la $a0, bonbon
		syscall
		j finStats
	sup1:
		la $a0, game_over
		syscall
		la $a0, score
		syscall
		li $v0, 1
		move $a0, $t0
		syscall
		li $v0, 4
		la $a0, bonbons
		syscall
		j finStats

	finStats:

	##### epilogue #####
	lw $t0, 4($sp)
	lw $ra, 0($sp)
	addu $sp, $sp, 8
# Fin.

jr $ra
