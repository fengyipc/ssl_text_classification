#!/usr/bin/env bash

NAME="dbpedia_pretrained"
OUT="temp/$NAME"

mkdir -p ${OUT}

# Preprocess
python preprocess.py --corpus dbpedia --output ${OUT}/data --vocab_size 50000 --save_data "demo_fastText"

# Create pre-trained word
python w2v.py --input ${OUT}/data --save_data "demo_fastText" --embeddings "${HOME}/crawl-300d-2M.vec"

exit
# Train the model
PYTHONIOENCODING=utf-8 python main.py --corpus dbpedia --model LSTMEncoder --debug --save_data "demo_fastText" \
--multi_gpu --input ${OUT}/data --output_path ${OUT}/model --exp_name "dbpedia_clf_" \
--use_pretrained_embeddings --train_embeddings --nepoch_no_imprv 20 --timedistributed --d_hidden 512 --nepochs 30 \
--optim adam --wbatchsize 2000 --wbatchsize_unlabel 2000 --eval_steps 1000 --lstm_dropout 0.5 --word_dropout 0.5 --beta1 0.0 --num_layers 1 --beta2 0.98 --scheduler "ExponentialLR" --lambda_vat 1.0 --lambda_entropy 0.0 --lambda_at 1.0