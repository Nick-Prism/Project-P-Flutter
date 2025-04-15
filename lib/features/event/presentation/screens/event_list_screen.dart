import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../../../../core/widgets/loading_overlay.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${eventProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => eventProvider.fetchEvents(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (eventProvider.events.isEmpty) {
            return const Center(
              child: Text('No events found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => eventProvider.fetchEvents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventProvider.events.length,
              itemBuilder: (context, index) {
                final event = eventProvider.events[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: EventCard(
                    event: event,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/events/details',
                        arguments: event,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/events/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
