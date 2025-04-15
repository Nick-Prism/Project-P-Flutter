import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/event_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../../../../core/widgets/loading_overlay.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isLoading = false;

  bool _isUserRegistered() {
    final authProvider = context.read<AuthProvider>();
    return widget.event.registeredAttendees.contains(authProvider.user?.uid);
  }

  bool _canUserRegister() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    return user != null &&
        user.firstName != null &&
        user.lastName != null &&
        user.usn != null &&
        user.phoneNumber != null;
  }

  Future<void> _handleRegistration() async {
    final authProvider = context.read<AuthProvider>();
    if (!_canUserRegister()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please complete your profile before registering for events'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushNamed(
          context,
          '/profile/setup',
          arguments: authProvider.user,
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<EventProvider>().registerForEvent(
            widget.event.id!,
            authProvider.user!.uid,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered for the event!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.event.posterUrl != null
                  ? Image.network(
                      widget.event.posterUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.event, size: 48),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    text:
                        '${widget.event.eventDate.day}/${widget.event.eventDate.month}/${widget.event.eventDate.year}',
                  ),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    text: widget.event.eventTime,
                  ),
                  _buildInfoRow(
                    icon: Icons.location_on,
                    text: widget.event.venue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildAttendeesSection(),
                  const SizedBox(height: 24),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendees',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${widget.event.registeredAttendees.length}/${widget.event.maxAttendees} registered',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        if (widget.event.registeredAttendees.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.event.registeredAttendees
                .map((attendee) => Chip(
                      label: Text(attendee),
                      avatar: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    final isRegistered = _isUserRegistered();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isRegistered || _isLoading ? null : _handleRegistration,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(isRegistered ? 'Registered' : 'Register for Event'),
      ),
    );
  }
}
