#!/usr/bin/env node
import { Channel, connect } from 'amqplib';
import { WebSocket, WebSocketServer } from 'ws';

type Message = { name: string; message: string; };
type History = { messages: Array<Message> }

const server = new WebSocketServer({ port: 4040 });
const history: History = { messages: [] };
const queue = 'hello';
const options = { noAck: true };

server.on('connection', function connection(socket) {
    socket.on('error', console.error);
    socket.on('message', (data, isBinary) => {
        server.clients.forEach((client) => {
            //if (client !== ws)
            if (client.readyState === WebSocket.OPEN) {
                client.send(data, { binary: isBinary });
                history.messages.push(JSON.parse(data.toString())); //TODO 
            }
        });
    });
    socket.send(JSON.stringify(history.messages)); //TODO 
});

const consume = (msg: any) => {
    console.log(" [<] %s", msg.content.toString());
    server.clients.forEach((client) => {
        client.send(msg.content.toString())
    });
};

const onConnect = (error: any, connection: any) => {
    if (error) throw error;
    connection.createChannel(channel);
};

const channel = (error: any, channel: Channel) => {
    if (error) throw error;
    console.log(" [*] Waiting for messages in '%s' queue. To exit press CTRL+C", queue);
    channel.assertQueue(queue, { durable: false });
    channel.consume(queue, consume, options);
};

connect('amqp://localhost', onConnect);