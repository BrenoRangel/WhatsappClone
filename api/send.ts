#!/usr/bin/env node

const amqp = require('amqplib/callback_api');
const yargs = require('yargs').argv;

const queue = 'hello';

const onConnect = (error0: any, connection: any, name: any) => {
    if (error0) throw error0;
    connection.createChannel((error0: any, connection: any) => channel(error0, connection, name));
    setTimeout(() => {
        connection.close();
        process.exit(0);
    }, 500);
}

const channel = (error1: any, channel: any, name: any) => {
    if (error1) throw error1;
    const msg = `Hello, ${name}!`;
    channel.assertQueue(queue, { durable: false });
    channel.sendToQueue(queue, Buffer.from(msg));
    console.log(" [>] %s", msg);
};

amqp.connect('amqp://localhost', (error: any, connection: any) => onConnect(error, connection, yargs.name ?? yargs.n));