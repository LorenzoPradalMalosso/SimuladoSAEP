<div class="card" style="max-width: 500px; margin: 0 auto;">
    <?php
        $agendamento = $agendamento ?? [];
        $petNome = $agendamento['pet_nome'] ?? '—';
        $tutorNome = $agendamento['tutor_nome'] ?? '—';
        $dataAgendamento = $agendamento['data_agendamento'] ?? '';
        $horaAgendamento = $agendamento['hora_agendamento'] ?? '';
        $agendamentoId = (int)($agendamento['id'] ?? 0);
    ?>

    <h2><?= htmlspecialchars($titulo ?? 'Editar data do agendamento') ?></h2>
    <p style="color:#94a3b8; font-size:0.88rem;">
        Paciente: <strong><?= htmlspecialchars($petNome) ?></strong> | 
        Tutor: <strong><?= htmlspecialchars($tutorNome) ?></strong>
    </p>

    <form action="/agendamentos/atualizar-data" method="POST">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrfToken ?? '') ?>">
        <input type="hidden" name="id" value="<?= $agendamentoId ?>">

        <div class="form-group">
            <label for="data_agendamento">Nova Data de Agendamento</label>
            <input type="date" id="data_agendamento" name="data_agendamento" value="<?= htmlspecialchars($dataAgendamento) ?>" required>
        </div>

        <div class="form-group">
            <label for="hora_agendamento">Novo Horário</label>
            <input type="time" id="hora_agendamento" name="hora_agendamento" value="<?= htmlspecialchars(substr($horaAgendamento, 0, 5)) ?>">
        </div>

        <div style="display:flex; justify-content:space-between; margin-top:20px;">
            <a href="/agendamentos" style="color:#94a3b8; text-decoration:none;">← Cancelar</a>
            <button type="submit" class="btn btn-success">Salvar Nova Data</button>
        </div>
    </form>
</div>